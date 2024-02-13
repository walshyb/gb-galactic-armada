#!/bin/bash
compile() {
  # make directories if not exists:
  mkdir -p src/generated/backgrounds
  mkdir -p src/generated/sprites

  # Convert sprite .png resources to .2bpp
  all_sprites=$(find src/resources/sprites/ -name '*.png')
  for file in $all_sprites
    do
      # remove path and extension from filename
      filename=$(basename -- "$file")
      filename="${filename%.*}"

      # convert the file
      rgbgfx -c "#FFFFFF,#cfcfcf,#686868,#000000;" --columns -o src/generated/sprites/$filename.2bpp $file
  done

  # Convert background .png resources to .2bpp and .tilemap
  all_backgrounds=$(find src/resources/backgrounds/ -name '*.png')
  for file in $all_backgrounds
    do
      # remove path and extension from filename
      filename=$(basename -- "$file")
      filename="${filename%.*}"

      # create .2bpp file
      rgbgfx -c "#FFFFFF,#cbcbcb,#414141,#000000;" -o src/generated/backgrounds/$filename.2bpp $file
      
      # create .tilemap
      rgbgfx -c "#FFFFFF,#cbcbcb,#414141,#000000;" \
        --tilemap src/generated/backgrounds/$filename.tilemap \
        --unique-tiles \
        -o src/generated/backgrounds/$filename.2bpp \
        $file
  done


  # Compile all .asm files and store objects in obj/
  all_asm_files=$(find . -name '*.asm')
  # loop through libs asm files 
  for file in $all_asm_files
    do
      # remove path and extension from filename
      filename=$(basename -- "$file")
      filename="${filename%.*}"

      # compile the file
      rgbasm -o obj/$filename.o $file
  done

	# Link all the objects and output a .gb file
	rgblink -m dist/galactic.map -n dist/galactic.sym -o dist/galactic.gb ./obj/*.o

	rgbfix -v -p 0xFF dist/galactic.gb
  



  #
	# Compile the main file
	#rgbasm -o main.o main.asm

	# Compile the paddle
	#rgbasm -o ./objects/paddle.o ./objects/paddle.asm
	#rgbasm -o ./objects/ball.o ./objects/ball.asm
	#rgbasm -o input.o input.asm

	# Link all the objects and output a .gb file
	#rgblink -m brickbreak.map -n brickbreak.sym -o brickbreak.gb ./*.o ./*/**.o

	# Fix the header (adds checksum, logo, and ROM size) of the .gb file
	#rgbfix -v -p 0xFF brickbreak.gb
}

compile