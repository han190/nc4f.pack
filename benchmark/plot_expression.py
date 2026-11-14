"""Plot RAW, EXTR, and EXPR time against extent for each OP count."""

import matplotlib.pyplot as plt
import argparse
from pathlib import Path

import matplotlib

matplotlib.use("Agg")


def read_results(path: Path) -> dict[int, list[tuple[int, float, float, float]]]:
    """Read EXTENT, OP, and the three timing paths from benchmark output."""
    results = {2: [], 8: [], 32: []}
    for line in path.read_text().splitlines():
        fields = line.split()
        if len(fields) < 8:
            continue
        try:
            extent = int(fields[0])
            op = int(fields[1])
            expr_ms = float(fields[2])
            extr_ms = float(fields[3])
            raw_ms = float(fields[4])
        except ValueError:
            continue
        if op in results:
            results[op].append(
                (extent, raw_ms * 1000.0, extr_ms * 1000.0, expr_ms * 1000.0)
            )

    if any(not points for points in results.values()):
        raise ValueError("Expected benchmark rows for OP = 2, 8, and 32")
    if any(time < 0 for points in results.values() for row in points for time in row[1:]):
        raise ValueError("Benchmark timings cannot be negative")
    return results


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path, help="Saved benchmark output")
    parser.add_argument(
        "output", type=Path, nargs="?", default=Path("benchmark/expression.svg"),
        help="Output figure (default: benchmark/expression.svg)",
    )
    args = parser.parse_args()
    results = read_results(args.input)

    fig, axes = plt.subplots(
        1, 3, figsize=(18, 5), sharex=True, sharey=True,
        layout="constrained",
    )
    for ax, op in zip(axes, (2, 8, 32)):
        points = sorted(results[op])
        for name, column, color in (
            ("RAW", 1, "red"),
            ("EXTR", 2, "green"),
            ("EXPR", 3, "blue"),
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
                label=name,
            )
        ax.set_title(f"OP = {op}")
        ax.set_xscale("log", base=2)
        ax.set_yscale("symlog", linthresh=1.0)
        ax.set_ylim(0, 1.0e6)
        ax.grid(True, which="both", alpha=0.25)

    extents = sorted({row[0] for points in results.values() for row in points})
    for ax in axes:
        ax.set_xticks(extents[::2], labels=[str(extent)
                      for extent in extents[::2]])
        ax.tick_params(axis="x", labelrotation=45)
    axes[0].legend(ncol=3)
    fig.supxlabel("Extent")
    fig.supylabel(r"Time ($10^{-3}$ ms)")
    args.output.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(args.output, dpi=200)


if __name__ == "__main__":
    main()
