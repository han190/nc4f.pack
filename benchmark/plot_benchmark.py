"""Plot NC4F and netcdf-fortran timings for the four I/O benchmark phases."""

import matplotlib.pyplot as plt
import argparse
import re
from pathlib import Path

import matplotlib

matplotlib.use("Agg")


PHASES = (
    ("create + write", "(a) create + write"),
    ("open + read", "(b) open + read"),
    ("calculate", "(c) calculate"),
    ("append theta", "(d) append theta"),
)
NUMBER = r"[-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[EeDd][-+]?\d+)?"
GRID = re.compile(r"^Grid:\s*(\d+)\s*x\s*(\d+);\s*repetitions:\s*\d+$")
ROW = re.compile(
    rf"^\s*(create \+ write|open \+ read|calculate|append theta)"
    rf"\s+({NUMBER})\s+({NUMBER})\s+\S+\s*$"
)


def read_results(path: Path) -> dict[str, list[tuple[int, float, float]]]:
    """Read per-grid phase means from the Fortran benchmark output."""
    results = {phase: [] for phase, _ in PHASES}
    grid_size = None
    seen = set()
    for line in path.read_text().splitlines():
        match = GRID.match(line.strip())
        if match:
            n, m = map(int, match.groups())
            if n != m:
                raise ValueError(f"Expected a square grid, found {n} x {m}")
            grid_size = n
            continue
        match = ROW.match(line)
        if match is None:
            continue
        if grid_size is None:
            raise ValueError("Found timing row before a grid header")
        phase, nc4f_text, nf90_text = match.groups()
        key = (grid_size, phase)
        if key in seen:
            raise ValueError(f"Duplicate {phase} result for n={grid_size}")
        seen.add(key)
        nc4f_ms = float(nc4f_text.replace("D", "E").replace("d", "e"))
        nf90_ms = float(nf90_text.replace("D", "E").replace("d", "e"))
        if nc4f_ms < 0 or nf90_ms < 0:
            raise ValueError("Benchmark timings cannot be negative")
        results[phase].append((grid_size, nc4f_ms, nf90_ms))

    if any(not points for points in results.values()):
        raise ValueError("Expected timing rows for all four phases")
    return results


def main() -> None:
    """Read benchmark output and write a four-panel timing figure."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path, help="Saved benchmark output")
    parser.add_argument(
        "output", type=Path, nargs="?", default=Path("benchmark/benchmark.svg"),
        help="Output image (default: benchmark/benchmark.svg)",
    )
    args = parser.parse_args()
    results = read_results(args.input)

    plt.rcParams.update({"font.size": 13})
    fig, axes = plt.subplots(2, 2, figsize=(12, 8), layout="constrained")
    fig.suptitle('NC4F vs. netcdf-fortran (smaller in better)')
    for ax, (phase, title) in zip(axes.flat, PHASES):
        points = sorted(results[phase])
        for label, column, color in (
            ("NC4F", 1, "tab:blue"),
            ("NF90", 2, "tab:red"),
        ):
            ax.plot(
                [row[0] for row in points],
                [row[column] for row in points],
                color=color,
                marker="o",
                markerfacecolor="white",
                markeredgecolor=color,
                markeredgewidth=1.5,
                linewidth=1.7,
                label=label,
            )
        ax.set_title(title, loc='left')
        ax.set_xscale("log", base=2)
        ax.set_yscale("symlog", linthresh=1e-3)
        times = [time for row in points for time in row[1:]]
        minimum, maximum = min(times), max(times)
        lower = 0 if minimum == 0 else minimum / 1.3
        upper = maximum * 1.3 if maximum > 0 else 1e-3
        ax.set_ylim(lower, upper)
        sizes = sorted({row[0] for row in points})
        ax.set_xticks(sizes, labels=[rf"${size}^2$" for size in sizes])
        ax.tick_params(axis="x", labelrotation=90)
        ax.set_xlabel("Grid size (n × n)")
        ax.set_ylabel("Time (ms)")
        # ax.grid(True, which="both", alpha=0.25)
        ax.legend(loc="upper left")

    args.output.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(args.output, dpi=300)


if __name__ == "__main__":
    main()
