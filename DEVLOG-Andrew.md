# Dev Log:

This document must be updated daily every time you finish a work session.

## Andrew Dickerson

### 2025-05-14 - Planning and outlining
- Made first draft of proposal, timeline, and prospected workflow.
- Added necessary components from image_processing lab.

### 2025-05-15 - Linking image_processing and audio_processing sketches
- Fixed image_processing to work with future audio encoding implementation. Changed paths to fix makefile to work in context of project.

### 2025-05-18 - Setting up makefile and test files
- Created example files for testing and demonstration purposes. 
- Fixed issue with image copying.
- Fixed encode to run both audio and image encoding with copied image.

### 2025-05-19 - Flag documentation
- Added comprehensive flag documentation for running makefile commands for each component of the project
- Commented the makefile, added a clean command.
- Fixed example make commands.
- Made data directory for file transfer between sketches.

### 2025-05-20 - 
- Revised setup, parseargs, and created settings for image_encoder to smooth transition into audio_encoder
- Removed excess flags in example make commands and in the README instructions
- Started setup and converting image to bytes for audio_encoder