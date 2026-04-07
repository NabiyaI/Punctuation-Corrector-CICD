import json

nb = json.load(open("Model_Training_Final.ipynb", "r", encoding="utf-8"))
for i, c in enumerate(nb["cells"]):
    ct = c["cell_type"]
    print(f"=== Cell {i} ({ct}) ===")
    for line in c["source"]:
        print(line, end="")
    print("\n")
