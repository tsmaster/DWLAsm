import os
import subprocess
import shutil

filenames = """
Chapter_01/prog_1_1.asm
Chapter_01/prog_1_2.asm
Chapter_01/prog_1_2a.asm
Chapter_01/prog_1_3.asm
Chapter_02/pal1.asm
Chapter_02/pal2.asm
Chapter_02/prog_2_10.asm
Chapter_02/prog_2_3.asm
Chapter_02/prog_2_4.asm
Chapter_02/prog_2_5.asm
Chapter_02/prog_2_6.asm
Chapter_02/prog_2_7.asm
Chapter_02/prog_2_8.asm
Chapter_03/prog_3_01.asm
Chapter_03/prog_3_02.asm
Chapter_03/prog_3_03.asm
Chapter_03/prog_3_04.asm
Chapter_03/prog_3_05.asm
Chapter_03/prog_3_06.asm
Chapter_03/prog_3_07.asm
Chapter_03/prog_3_08.asm
Chapter_03/prog_3_09.asm
Chapter_03/prog_3_10.asm
Chapter_03/prog_3_10m1.asm
Chapter_03/prog_3_11.asm
Chapter_04/prog_4_01.asm
Chapter_04/prog_4_02.asm
Chapter_04/prog_4_03.asm
Chapter_04/prog_4_04.asm
Chapter_04/prog_4_05.asm
Chapter_04/prog_4_06.asm
Chapter_04/prog_4_07.asm
Chapter_04/prog_4_08.asm
Chapter_05/prog_5_01.asm
Chapter_05/prog_5_01m2.asm
Chapter_05/prog_5_02.asm
Chapter_05/prog_5_02m1.asm
Chapter_05/prog_5_03.asm
Chapter_05/prog_5_03m1.asm
Chapter_06/prog_6_01.asm
Chapter_06/prog_6_02.asm
Chapter_06/prog_6_03.asm
Chapter_06/prog_6_04.asm
Chapter_06/prog_6_05.asm
Chapter_06/prog_6_05m1.asm
Chapter_06/prog_6_05m2.asm
Chapter_06/prog_6_05m3.asm
Chapter_06/prog_6_06.asm
Chapter_06/prog_6_06m1.asm
Chapter_06/prog_6_07.asm
Chapter_06/prog_6_07m1.asm
Chapter_06/prog_6_08.asm
Chapter_06/prog_6_08m1.asm
Chapter_07/prog_7_05.asm
Chapter_07/prog_7_07.asm
Chapter_08/prog_8_01.asm
Chapter_08/prog_8_02.asm
Chapter_08/prog_8_03.asm
Chapter_08/prog_8_06.asm
Chapter_08/prog_8_07.asm
Chapter_08/prog_8_08.asm
Chapter_08/prog_8_09.asm
Chapter_08/prog_8_10.asm
Chapter_08/prog_8_11.asm
Chapter_08/prog_8_12.asm
Chapter_08/prog_8_13.asm
Chapter_08/prog_8_14.asm
Chapter_08/prog_8_15.asm
Chapter_08/prog_8_16.asm
Chapter_08/prog_8_17.asm
Chapter_08/prog_8_19.asm
Chapter_08/prog_8_20.asm
Chapter_09/prog_9_01.asm
Chapter_10/prog_10_01.asm
Chapter_10/prog_10_02.asm
Chapter_10/prog_10_03.asm
Chapter_10/prog_10_04.asm
Chapter_10/prog_10_05.asm
Chapter_10/prog_10_06.asm
Chapter_10/prog_10_06m1.asm
Chapter_10/prog_10_07.asm
Chapter_10/prog_10_08.asm
Chapter_11/prog_11_01.asm
Chapter_11/prog_11_02.asm
Chapter_11/prog_11_03.asm
Chapter_11/prog_11_04.asm
Chapter_11/prog_11_05.asm
Chapter_11/prog_11_06.asm
Chapter_12/prog_12_01.asm
Chapter_13/prog_13_01.asm
Chapter_13/prog_13_02.asm
"""

results = {}

non_zero_filenames = []

for f in filenames.split():
    f = f.strip()
    rel_path = os.path.join('../ASM/AssemblyLanguageForTheApplesoftProgrammer', f)

    print("checking", rel_path)

    if not os.path.exists(rel_path):
        print("path does not exist")
        assert(False)
        
    completed_process = subprocess.run(["python3", "../asm.py", "--list", "test.list", "--out", "test.obj", rel_path])

    base, ext = os.path.splitext(f)
    golden_listing_filename = os.path.join("./GoldenLists/", base + ".glst")

    #print("gold:", golden_listing_filename)

    dirs = os.path.split(golden_listing_filename)

    if not os.path.exists(dirs[0]):
        os.makedirs(dirs[0])

    results[f] = completed_process.returncode

    if completed_process.returncode != 0:
        non_zero_filenames.append(f)

    if ((os.path.exists("test.list")) and
        (not os.path.exists(golden_listing_filename))):
        print("copying test.list to", golden_listing_filename)
        shutil.copyfile("test.list", golden_listing_filename)
    else:
        print ("TODO: compare test.list and", golden_listing_filename)

    if os.path.exists("test.obj"):
        os.unlink("test.obj")

    if os.path.exists("test.list"):
        os.unlink("test.list")

keys = list(results.keys())
keys.sort()

for k in keys:
    print (k, results[k])

if non_zero_filenames:
    print()
    print("non zero files")
    non_zero_filenames.sort()

    for nzf in non_zero_filenames:
        print(nzf, results[nzf])

              
