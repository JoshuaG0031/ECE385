from PIL import Image, ImageDraw, ImageFont

def get_dominant_colors(infile):
    image = Image.open(infile)
    
    # 缩小图片，否则计算机压力太大
    small_image = image.resize((80, 80))
    result = small_image.convert(
        "P", palette=Image.ADAPTIVE, colors=10
    )  
	
	# 7个主要颜色的图像

    # 找到主要的颜色
    palette = result.getpalette()
    color_counts = sorted(result.getcolors(), reverse=True)
    colors = list()

    for i in range(7):
        palette_index = color_counts[i][1]
        dominant_color = palette[palette_index * 3 : palette_index * 3 + 3]
        R='0x{:02X}'.format(dominant_color[0])
        G='{:02X}'.format(dominant_color[1])
        B='{:02X}'.format(dominant_color[2])
        RGB=R+G+B
        colors.append(RGB)

    # print(colors)
    return colors

image_path = r"./img/test.png"
color = get_dominant_colors(image_path)
print(color)