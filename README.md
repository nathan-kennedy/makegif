# MakeGIF

MakeGIF is a simple yet powerful shell script for creating optimized GIFs from video files. It leverages the power of `ffmpeg` and `gifsicle` to provide high-quality GIFs with customization options such as start time, duration, quality, and more.

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
2. Make the script executable:

   ```bash
   chmod +x makegif.sh
   ```

3. Optionally, move the script to a directory in your PATH or create an alias for easy access.

   - Moving to a directory in your PATH:

     ```bash
     sudo mv makegif.sh /usr/local/bin/makegif
     ```

   - Creating an alias (add this to your `.zshrc` or `.bashrc`):

     ```bash
     alias makegif="/path/to/makegif.sh"
     ```

## Usage

You can use MakeGIF in two modes: Interactive and Argument mode.

- **Interactive Mode**: Simply run `makegif` without arguments, and the script will guide you through the process.

  ```bash
  makegif
  ```

- **Argument Mode**: Provide details as arguments. Arguments wrapped with "< >" are required. Arguments wrapped with "[ ]" are optional.

  ```bash
  makegif <path_to_source_video> <start_time> <duration> <output_gif> <quality> [width] [fps] [num_colors]
  ```

### Parameters

- `source_video`: Path to the source video file.
- `start_time`: Start time of the GIF in the format hh:mm:ss. You don't need to follow this strictly; e.g. inputting '10' will work fine and be interpreted as 00:00:10, "1:10" will also work and be interpreted as 00:01:10.
- `duration`: Duration of the GIF in the format hh:mm:ss. You don't need to follow this strictly; e.g. inputting '10' will work fine and be interpreted as 00:00:10, "1:10" will also work and be interpreted as 00:01:10
- `output_gif`: Name of the output GIF file.
- `quality`: Quality of the GIF (high/low).
- `width`: Width of the output GIF (default: 640).
- `fps`: Frames per second (default: 10).
- `num_colors`: Number of colors for optimization (default & max: 256). Setting a lower this to a lower number helps dramatically with file size (GIFs get pretty large). Even using only 64 colors still looks pretty good.

## Examples

1. Creating a GIF in interactive mode:

   ```bash
   makegif
   ```

2. Creating a GIF with specified arguments:

   ```bash
   makegif video.mp4 01:10:05 00:00:10 output.gif high 640 15 128
   ```

## Troubleshooting

- Ensure `ffmpeg` and `gifsicle` are correctly installed.
- Check the syntax and format of your command if encountering errors.
- For more help, [open an issue](https://github.com/nathan-kennedy/makegif/issues) on GitHub.

## License

[MIT License](https://github.com/nathan-kennedy/makegif/blob/master/LICENSE)

## Contributions

Contributions are welcome!
