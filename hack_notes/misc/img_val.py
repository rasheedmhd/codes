import magic
file_type = magic.from_file("upload.png", mime=True)
assert file_type == "image/png"