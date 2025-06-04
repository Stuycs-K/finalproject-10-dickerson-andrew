# Example Make Commands

## Full Encoder (Runs both image and audio encoders on the same args):
1. Encodes the message from `examples/input/lorem_ipsum.txt`, using the `GREEDY` mode, into the image `examples/input/cat.png`. Then encodes the encoded image result, `../../examples/output/image_encoded.png` into the audio file `../../examples/input/solar.wav`. The final result is stored in the file `../../examples/output/audio_encoded.wav`, but is not automatically displayed.

> make encode ARGS="-iI examples/input/cat.png -oI ../../examples/output/image_encoded.png -p examples/input/lorem_ipsum.txt -m GREEDY -dI FALSE -iP ../../examples/output/image_encoded.png -iA ../../examples/input/solar.wav -oA ../../examples/output/audio_encoded.wav"

2. Encodes the message from `examples/input/secret_short.txt`, using the `SELECTIVE` mode, into a blank, 100 pixel by 100 pixel, white image, since no input image was provided. Then encodes the encoded image result, `../../examples/output/image_encoded.png` into the audio file `../../examples/input/silence.wav`. The final result is stored in the file `../../examples/output/audio_encoded.wav`, but is not automatically displayed.

> make encode ARGS="-oI ../../examples/output/image_encoded.png -p examples/input/secret_short.txt -m GREEDY -dI FALSE -iP ../../examples/output/image_encoded.png -iA ../../examples/input/silence.wav -oA ../../examples/output/audio_encoded.wav"

3. Encodes the plaintext message, "This is a secret message", using the `GREEDY` mode, into the image `../../examples/input/rainbow.png`. Then encodes the encoded image result, `../../examples/output/image_encoded.png` into the audio file `../../examples/input/solar.wav`. The final result is stored in the file `../../examples/output/audio_encoded.wav`, but is not automatically displayed.

> make encode ARGS="-iI examples/input/rainbow.png -oI ../../examples/output/image_encoded.png -p 'This is a plain text secret message' -m GREEDY -dI FALSE -iP ../../examples/output/image_encoded.png -iA ../../examples/input/solar.wav -oA ../../examples/output/audio_encoded.wav"


## Full Decoder (Runs both image and audio decoders on the same args):
1. Decodes the image, `../../examples/output/audio_decoded.png`, from the wav file `../../examples/output/audio_encoded.wav`. Then decodes the message embeded within the decoded image result, `../../examples/output/image_encoded.png`, which is not automatically displayed. The final decoded message found using the `GREEDY` mode, and is stored in the file `../../examples/output/image_decoded.txt`.

> make decode ARGS="-iA ../../examples/output/audio_encoded.wav -oA ../../examples/output/audio_decoded.png -dA TRUE -iI ../../examples/output/image_encoded.png -oI ../../examples/output/image_decoded.txt -m GREEDY"

2. Decodes the image, `../../examples/output/audio_decoded.png`, from the wav file `../../examples/output/audio_encoded.wav`. Then decodes the message embeded within the decoded image result, `../../examples/output/image_encoded.png`, which is not automatically displayed. The final decoded message found using the `SELECTIVE` mode, and is stored in the file `../../examples/output/image_decoded.txt`.

> make decode ARGS="-iA ../../examples/output/audio_encoded.wav -oA ../../examples/output/audio_decoded.png -dA TRUE -iI ../../examples/output/image_encoded.png -oI ../../examples/output/image_decoded.txt -m GREEDY"


3. Decodes the image, `../../examples/output/audio_decoded.png`, from the wav file `../../examples/output/audio_encoded.wav`. Then decodes the message embeded within the decoded image result, `../../examples/output/image_encoded.png`, which is not automatically displayed. The final decoded message found using the `GREEDY` mode, and is stored in the file `../../examples/output/image_decoded.txt`.

> make decode ARGS="-iA ../../examples/output/audio_encoded.wav -oA ../../examples/output/audio_decoded.png -dA TRUE -iI ../../examples/output/image_encoded.png -oI ../../examples/output/image_decoded.txt -m GREEDY"


## Image Encoder:
1. (a) Short Secret into Cat:
> make image_encode ARGS="-iI ../../examples/input/cat.png -oI ../../examples/output/image_encoded.png -p examples/input/secret_short.txt -m GREEDY -dI TRUE"

1. (b) Plain Text into Cat:
> make image_encode ARGS="-iI ../../examples/input/cat.png -oI ../../examples/output/image_encoded.png -p msg -m GREEDY -dI TRUE"

2. Lorem into Blank, Selective:
> make image_encode ARGS="-oI ../../examples/output/image_encoded.png -p examples/input/lorem_ipsum.txt -m SELECTIVE -dI TRUE"

3. Plain Text into Rainbow:
> make image_encode ARGS="-iI ../../examples/input/rainbow.png -oI ../../examples/output/image_encoded.png -p "This is a secret message" -m GREEDY -dI TRUE"


## Image Decoder:
1. (a) Short from Cat, Greedy:
> make image_decode ARGS="-iI ../../examples/output/image_encoded.png -oI ../../examples/output/image_decoded.txt -m GREEDY"

1. (b) Plain from Cat, Greedy:
> make image_decode ARGS="-iI ../../examples/output/image_encoded.png -oI ../../examples/output/image_decoded.txt -m GREEDY"

2. Lorem from Blank, Selective:
> make image_decode ARGS="-iI ../../examples/output/image_encoded.png -oI ../../examples/output/image_decoded.txt -m SELECTIVE"

3. Plain from Rainbow, Greedy:
> make image_decode ARGS="-iI ../../examples/output/image_encoded.png -oI ../../examples/output/image_decoded.txt -m GREEDY"


## Image Diff:
1. Cat diff:
> make image_diff ARGS="-m ../../examples/output/audio_decoded.png -o ../../examples/output/image_encoded.png"

2. Blank diff:
> make image_diff ARGS="-m ../../examples/output/audio_decoded.png -o ../../examples/output/image_encoded.png"

3. Rainbow diff:
> make image_diff ARGS="-m ../../examples/output/audio_decoded.png -o ../../examples/output/image_encoded.png"


## Audio Encoder:
1. Encoded Cat into solar:
> make audio_encode ARGS="-iP ../../examples/output/image_encoded.png -iA ../../examples/input/solar.wav -oA ../../examples/output/audio_encoded.wav"

2. Blank into Silent:
> make audio_encode ARGS="-iP ../../examples/output/image_encoded.png -iA ../../examples/input/silence.wav -oA ../../examples/output/audio_encoded.wav"

3. Rainbow into solar:
> make audio_encode ARGS="-iP ../../examples/output/image_encoded.png -iA ../../examples/input/solar.wav -oA ../../examples/output/audio_encoded.wav"


## Audio Decoder:
1. Encoded Cat from solar:
> make audio_decode ARGS="-iA ../../examples/output/audio_encoded.wav -oA ../../examples/output/audio_decoded.png -dA TRUE"

2. Blank from Silent:
> make audio_decode ARGS="-iA ../../examples/output/audio_encoded.wav -oA ../../examples/output/audio_decoded.png -dA TRUE"

3. Rainbow from solar:
> make audio_decode ARGS="-iA ../../examples/output/audio_encoded.wav -oA ../../examples/output/audio_decoded.png -dA TRUE"


## Audio Diff:
1. Cat diff:
> make audio_diff ARGS="-m ../../examples/output/audio_encoded.wav -o ../../examples/input/solar.wav -v FALSE"

2. Blank diff:
> make audio_diff ARGS="-m ../../examples/output/audio_encoded.wav -o ../../examples/input/silence.wav -v FALSE"

3. Rainbow diff:
> make audio_diff ARGS="-m ../../examples/output/audio_encoded.wav -o ../../examples/input/solar.wav -v FALSE"


## Clean:
> make clean
