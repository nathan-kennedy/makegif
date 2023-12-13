# MakeGIF

MakeGIF is a simple yet powerful shell script for creating optimized GIFs from video files. It leverages the power of `ffmpeg` and `gifsicle` to provide high-quality GIFs with customization options such as start time, duration, quality, and more. Leave the parameters empty to start interactive mode and have the program prompt you for the parameters line-by-line for ease of use.

## Features

- Convert video to GIF with custom settings.
- Interactive mode for ease of use.
- Command-line arguments for quick operation.
- High and low-quality options.
- Customizable dimensions, frame rate, and color depth.

## Prerequisites

Before you start using MakeGIF, you need to have `ffmpeg` and `gifsicle` installed on your system. If you don't have them installed, you can install them using Homebrew:

```bash
brew install ffmpeg gifsicle
```

## Installation

1. Download the `makegif.sh` script from this repository.
2. Source the script inside your .zshrc (I source mine in a separate file for functions - they essentially act just like aliases and are called the same way too).

## Usage

You can use MakeGIF in two modes: Interactive and Argument mode.

- **Interactive Mode**: Simply run `makegif` without arguments, and the script will guide you through the process.

  ```bash
  makegif
  ```

- **Argument Mode**: Provide details as arguments. Arguments wrapped with "< >" are required. Arguments wrapped with "[ ]" are optional.

  ```bash
  makegif <path_to_source_video> <start_time> <duration> <output_gif> <quality> [width] [fps] [num_colors] [remove_black_bars]
  ```  

#### Parameters  

- `source_video`: Path to the source video file.
- `start_time`: Start time of the GIF in the format hh:mm:ss. You don't need to follow this strictly; e.g. inputting '10' will work fine and be interpreted as 00:00:10, "1:10" will also work and be interpreted as 00:01:10.
- `duration`: Duration of the GIF in the format hh:mm:ss. You don't need to follow this strictly; e.g. inputting '10' will work fine and be interpreted as 00:00:10, "1:10" will also work and be interpreted as 00:01:10
- `output_gif`: Name of the output GIF file.
- `quality`: Quality of the GIF (high/low).
- `width`: Width of the output GIF (default: 640).
- `fps`: Frames per second (default: 10).
- `num_colors`: Number of colors for optimization (default & max: 256). Setting a lower this to a lower number helps dramatically with file size (GIFs get pretty large). Even using only 64 colors still looks pretty good.
- `remove_black_bars`: Yes/no boolean dictates whether or not the script attempts to
  automatically remove the black bars from top and bottom of video.  

### Cropping a GIF Square  

- **Square Crop Mode**: Needs to be run as a separate command after creating
your GIF because the function was causing bugs with how it interacted with the black
bar removal.
  ```bash
  squaregif <original_gif_name> <output_gif_name> [left \| right \| center \| top
  \|bottom]
  ```

## Examples

1. Creating a GIF in interactive mode:

   ```bash
   makegif
   ```

2. Creating a GIF with specified arguments:

   ```bash
   makegif makegif video.mp4 01:10:05 00:00:10 output.gif high 640 15 128
   ```

3. Making the GIF square

    ```bash
    squaregif "uncroppedgif.gif" "croppedgif.gif" center 
    ```

## Troubleshooting

- Ensure `ffmpeg` and `gifsicle` are correctly installed.
- Check the syntax and format of your command if encountering errors.
- For more help, [open an issue](https://github.com/nathan-kennedy/makegif/issues) on GitHub.

## License

[MIT License](https://github.com/nathan-kennedy/makegif/blob/master/LICENSE)

## Contributions

Contributions are welcome!
