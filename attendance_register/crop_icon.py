from PIL import Image

def crop_white_borders(image_path, output_path):
    img = Image.open(image_path).convert("RGBA")
    data = img.load()
    width, height = img.size
    
    # Trova i confini non bianchi
    left, top, right, bottom = width, height, 0, 0
    for y in range(height):
        for x in range(width):
            r, g, b, a = data[x, y]
            # Consider white background
            if not (r > 240 and g > 240 and b > 240):
                if x < left: left = x
                if y < top: top = y
                if x > right: right = x
                if y > bottom: bottom = y

    # Aggiungi un piccolo margine per non tagliare troppo a vivo, o no, tagliamo a vivo!
    if right >= left and bottom >= top:
        # Per Android Adaptive Icon, il foreground dovrebbe riempire bene lo spazio.
        cropped = img.crop((left, top, right, bottom))
        # Ridimensiona a 1024x1024 se si vuole, o lascia così
        cropped.save(output_path)
        print("Cropped successfully from", (left, top, right, bottom))
    else:
        print("Could not crop.")

crop_white_borders("assets/icon/icon.png", "assets/icon/icon_cropped.png")
