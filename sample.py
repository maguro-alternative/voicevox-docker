import argparse
from pathlib import Path
import voicevox_core
from voicevox_core import AccelerationMode, AudioQuery, VoicevoxCore

open_jtalk_dict_dir = '/go/open_jtalk_dic_utf_8-1.11'
text = 'これはテストです'
acceleration_mode = AccelerationMode.AUTO
parser = argparse.ArgumentParser()
parser.add_argument("--speaker", help="please set speaker id", type=int)
parser.add_argument("--text", help="please set text", type=str)
parser.add_argument("--out", help="please set output file path", type=str)

def main() -> None:
    args = parser.parse_args()
    core = VoicevoxCore(
        acceleration_mode=acceleration_mode, open_jtalk_dict_dir=open_jtalk_dict_dir
    )
    core.load_model(args.speaker)
    audio_query = core.audio_query(args.text, args.speaker)
    wav = core.synthesis(audio_query, args.speaker)
    Path(args.out).write_bytes(wav)

if __name__ == "__main__":
    main()