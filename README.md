# Work Folder

This folder is for daily R workflow and temporary project work.

## Structure

- `00_inbox/`: quick drop zone for incoming files
- `01_data/`: data staging (`raw`, `clean`, `external`)
- `02_scripts/`: scripts by purpose (`etl`, `analysis`, `modeling`, `visualization`)
- `03_reports/`: report sources (`rmarkdown`, `quarto`)
- `04_outputs/`: generated outputs (`figures`, `tables`, `models`)
- `05_logs/`: run logs
- `06_temp/`: temporary files
- `07_archive/`: archived materials

## Notes

- Keep `01_data/raw/` read-only when possible.
- Put reusable helper code under `02_scripts/`.
- Generated outputs should go to `04_outputs/`.
