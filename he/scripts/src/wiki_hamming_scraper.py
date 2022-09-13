import pandas as pd

table = pd.read_html("https://en.wikipedia.org/wiki/Hamming(7,4)")[4]

conv = {c: lambda x: str(x) for c in table.columns}
table = pd.read_html("https://en.wikipedia.org/wiki/Hamming(7,4)", converters=conv)[4]

for index in table.index:
    table.loc[index]["Hamming(7,4)"]["Transmitted"] = table.loc[index]["Hamming(7,4)"][
        "Transmitted"
    ][::-1]
    table.loc[index]["Data"]["Data"] = table.loc[index]["Data"]["Data"][::-1]

print(table[["Data", "Hamming(7,4)"]])
