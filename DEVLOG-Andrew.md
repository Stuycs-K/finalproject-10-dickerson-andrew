# Dev Log:

This document must be updated daily every time you finish a work session.

## Andrew Dickerson

### 2025-05-14 - Planning and outlining.
- Made first draft of proposal, timeline, and prospected workflow.
- Added necessary components from `image_processing` lab.

### 2025-05-15 - Linking `image_processing` and `audio_processing` sketches.
- Fixed `image_processing` to work with future audio encoding implementation. Changed paths to fix makefile to work in context of project.

### 2025-05-18 - Setting up makefile and test files.
- Created example files for testing and demonstration purposes. 
- Fixed issue with image copying.
- Fixed encode to run both audio and image encoding with copied image.

### 2025-05-19 - Flag documentation.
- Added comprehensive flag documentation for running makefile commands for each component of the project.
- Commented the makefile, added a clean command.
- Fixed example make commands.
- Made data directory for file transfer between sketches.

### 2025-05-20 - Setup for image and audio encoder.
- Revised setup, parseargs, and created settings for `image_encoder` to smooth transition into audio_encoder.
- Removed excess flags in example make commands and in the README instructions.
- Started setup and converting image to bits for `audio_encoder`.

### 2025-05-21 - Issues installing sound library for `audio_encoder`.
- Library installed in processing but unable to be found after running make command, not sure how to fix this yet.
- Otherwise, wrote prelimnary methods for `audio_encoder`.
- Minor tweaks to DEVLOG format.
- Change file organization within `audio_processing` sketch.

### 2025-05-22 - Saved an audio file with `audio_encoder`.
- Library seems to work fine on lab machine, not sure what the issue is on personal device.
- Fixed save destination for example command for `audio_encoder`.
- Successfully saved file after encoding audio, unable to test without decoder though. 
- Removed PROPOSAL.md as directed on piazza.

### 2025-05-23 - Framework for `audio_decoder`.
- Repurposed basic methods and intializations from `audio_encoder` into `audio_decoder`.
- Added potential display flags for both audio sketches.
- Updated example make commands to include new audio display flags.

### 2025-05-24 - Wrote more methods for `audio_decoder`.
- Wrote methods for extractBitsFromWav and bitArrayToImage in `audio_decoder`.

### 2025-05-25 - Completed all methods for `audio_decoder`, unable to test yet as described below.
- Replaced preliminary code for bits to img method.
- Added run sequence to setup in audio decoder.
- Can't test on local since wsl can't detect the library.

### 2025-05-26 - Created symbolic link and uncovered issues with `audio_decoder`.
- Created symbolic link for allow for proper testing on local device for audio programs.
- Fixed path in example make file audio input for `audio_decoder`.
- Fixed flag name for audio input in `audio_decoder`.
- Discovered issue with saving text file using .save() in `audio_decoder`.

### 2025-05-27 - Instruction modification and error handling.
- Updated user instructions for running and interaction with program.
- Added group name.
- Changed format of `README` for readability.
- Fixed issue where provided `oxp.wav` file was too small to contain encoded image.
- Fixed issue where `image_encoder` wouldn't correctly interpret image paths using `-p` flag.
- Fixed issue where `image_decoder` wouldn't stop properly after receiving termination sequence.
- Added warning statements to `image_encoder` and `image_decoder`.
- Changed example file names for easier comprehension of use in example make files.

### 2025-05-28 - Reduced instrusivity of `audio_encoder`
- Removed extra flags from `audio_encoder` in instructions.
- Changed `audio_encoder` and `audio_decoder` to try and retrieve full image with less instrusive encoding.
- Successfully decoded a message using `audio_decoder` but the retrieved image is still off.

### 2025-05-29 - Debugging `audio_encoder` and `audio_decoder`.
- Fixed parity issues between `audio_encoder` and `audio_decoder`.
- Successfully decoded part of original image using `audio_decoder`.
- Began changing file and naming structure for `/examples`.

### 2025-05-30 - Debugging and make command format.
- Modified example make command format and names to increase ease of use.
- Added additional cases and debug statements.

### 2025-06-1 - Debugging and test cases.
- Fixed issue with flag listing when receiving invalid arguments for `audio_decoder`.
- Added more test cases with clearer input image.
- Narrowed down issue to insufficient space in wav file for encoding full image with current encoding methods.

### 2025-06-2 - Debugging and compatability fixes.
- Wrote audio diff for finding issues in audio encoder and decoder
- Fixed issue where wav file could be too small to contain image.
- Added encoding image dimensions into audio file to remove -w and -h flags.
- Began fixing issue where encoded wav file is not valid wav file.

### 2025-06-3 - Debugging and final submission.
- Wrote test cases for full encoder and full decoder.
- Fixed issue where encoded wav file was not detected as valid wav file by programs like audacity.
- Fixed issue where image dimensions were not being encoded properly.
- Fixed issue where default blank image would not properly contain encoded information.
- Completed presentation outline in `presenation.md`
- Recorded final presentation video.
