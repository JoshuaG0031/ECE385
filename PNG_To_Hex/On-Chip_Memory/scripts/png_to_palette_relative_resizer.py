from PIL import Image
from dominate import get_dominant_colors
from collections import Counter
from scipy.spatial import KDTree
import numpy as np
import math
def hex_to_rgb(num):
    h = str(num)
    return int(h[0:4], 16), int(('0x' + h[4:6]), 16), int(('0x' + h[6:8]), 16)
def rgb_to_hex(num):
    h = str(num)
    return int(h[0:4], 16), int(('0x' + h[4:6]), 16), int(('0x' + h[6:8]), 16)
filename = input("What's the image name? ")
image_path="../sprite_originals/" + filename+ ".png"
# image_path="C:/Users/moyang.19/Documents/GitHub/ECE385/PNG To Hex/On-Chip Memory/sprite_originals" + filename+ ".png"
color=get_dominant_colors(image_path)
palette_hex=['0x800080']
palette_hex.extend(color)
new_w, new_h = map(int, input("What's the new height x width? Like 28 28. ").split(' '))
# palette_hex = ['0x800080','0x000000', '0x15ADE9', '0x9AD9E9', '0xF0F2EE', '0x6193A3', '0x63D6F3', '0x1C6997']
pix_num = int(new_w) * int(new_h)
address_len = int(math.log2(pix_num))
print("\n---Copy the following code to the ROM module---\n")
print("module", filename)
print("(\n\t\tinput [",address_len,":0] read_address,\n\t\toutput logic [23:0] pixel_color\n);\n",sep="")
print("logic [3:0] ram [0:",pix_num-1,"];",sep="")
print("logic [23:0] palette [10:0];")
for i in range(len(palette_hex)):
    print("assign palette[",i,"] = 24\'h",palette_hex[i][2:],";",sep='')
print("assign pixel_color = palette[ram[read_address]];")
print("\ninitial\nbegin\n\t$readmemh(\"../PNG_To_Hex/On-Chip_Memory/sprite_bytes/",filename,".txt\",ram);",sep="")
print("end\n\nendmodule")
palette_rgb = [hex_to_rgb(color) for color in palette_hex]
pixel_tree = KDTree(palette_rgb)
im = Image.open(image_path) #Can be many different formats.
im = im.convert("RGBA")
im = im.resize((new_w, new_h),Image.ANTIALIAS) # regular resize
pix = im.load()
pix_freqs = Counter([pix[x, y] for x in range(im.size[0]) for y in range(im.size[1])])
pix_freqs_sorted = sorted(pix_freqs.items(), key=lambda x: x[1])
pix_freqs_sorted.reverse()
#print(pix)
outImg = Image.new('RGB', im.size, color='white')
outFile = open("../sprite_bytes/" + filename + '.txt', 'w')
i = 0
for y in range(im.size[1]):
    for x in range(im.size[0]):
        pixel = im.getpixel((x,y))
        #print(pixel)
        if(pixel[3] < 200):
            outImg.putpixel((x,y), palette_rgb[0])
            outFile.write("%x\n" % (0))
            # print(i)
        else:
            index = pixel_tree.query(pixel[:3])[1]
            outImg.putpixel((x,y), palette_rgb[index])
            outFile.write("%x\n" % (index))
        i += 1
outFile.close()
outImg.save("../sprite_converted/" + filename + ".png")
