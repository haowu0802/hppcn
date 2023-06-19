import os

# find all files in hpp
for root, dirs, files in os.walk("./"):
    print(root, dirs, files)

# find all files in cn patch
cn_patch_path = "../_hoi3cnv3"


# find common files
