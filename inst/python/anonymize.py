from pathlib import Path
from typing import Union
import spacy
import argparse
from fuzzywuzzy import process
from fuzzysearch import find_near_matches
from .extract import extract_text
from re import compile

nlp = spacy.load("en_core_web_md")


def __init_argparse() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        usage="%(prog)s [OPTIONS] FILE [ACTOR ...]",
        description="Anonymize file, removing provided actors and optionally extracting actors from the cover page.",
    )
    parser.add_argument(
        "file",
        metavar="FILE",
        help="file to anonymize",
    )
    parser.add_argument(
        "actors",
        nargs="*",
        metavar="ACTOR",
        help="named actors to remove",
    )
    parser.add_argument(
        "-o",
        "--outdir",
        dest="outdir",
        help="path to output directory (default: current working directory)",
    )
    parser.add_argument(
        "-c",
        "--cover-page",
        dest="cover",
        help="should the cover page be scanned for named entities to remove?",
        action="store_true",
    )
    parser.add_argument(
        "-r",
        "--regex",
        metavar="PATTERN",
        dest="patterns",
        nargs="*",
        help="one or more regex patterns to remove",
    )
    return parser


def get_person_entities(text: str) -> list[str]:
    # todo: simple pre-trained model, ask Anna if she has ideas for a better one.
    out = set()
    for ent in nlp(text).ents:
        if ent.label_ == "PERSON" and len(ent.text) >= 5:
            out.add(ent.text)
    return list(out)


def anonymize(
    text: str,
    actors: list[str] = [],
    patterns: list[str] = [],
):
    if actors:
        text = anonymize_known_persons(text, actors)

    if patterns:
        text = anonymize_patterns(text, patterns)

    return text


def anonymize_dates(text: str, replace: bool = False) -> str:
    dates = [
        date.text
        for date in nlp(text).ents
        if (date.label_ == "DATE" or date.label_ == "TIME") and len(date.text) > 4
    ]
    for id, date in enumerate(dates):
        if replace:
            text = text.replace(date, f"DATE{id}")
        else:
            text = text.replace(date, "")
    return text


def anonymize_unknown_persons(text: str, replace: bool = False) -> str:
    persons = get_person_entities(text)
    return anonymize_known_persons(text, persons, replace)


def anonymize_patterns(
    text: str, patterns: list[str], replace: Union[list[str], bool] = False
) -> str:
    for id, pattern in enumerate(patterns):
        for match in compile(pattern).findall(text):
            if replace:
                if isinstance(replace, list):
                    text = text.replace(match, replace[id])
                else:
                    text = text.replace(match, f"PATTERN{id}")
            else:
                text = text.replace(match, "")
    return text


def anonymize_known_persons(
    text: str, persons: list[str], replace: Union[bool, list[str]] = False
) -> str:

    for entity in set(get_person_entities(text)):
        match = process.extractOne(entity, persons)
        if match and match[1] >= 90:
            if replace:
                id = persons.index(match[0])
                if isinstance(replace, list):
                    text = text.replace(entity, list[id])
                else:
                    text = text.replace(entity, f"PERSON{id}")
            else:
                text = text.replace(entity, "")

    for id, person in enumerate(persons):
        matches = find_near_matches(person, text, max_l_dist=1)
        matches.reverse()
        for match in matches:
            if replace:
                if isinstance(replace, list):
                    text = __replace_substring(
                        text, match.start, match.end, replace[id]
                    )
                else:
                    text = __replace_substring(
                        text, match.start, match.end, f"PERSON{id}"
                    )
            else:
                text = __replace_substring(text, match.start, match.end, "")

    return text


def __replace_substring(
    string: str, start: int, end: int, replacement: str = ""
) -> str:
    return string[:start] + replacement + string[end:]


def __main():
    args = __init_argparse().parse_args()
    path = Path(args.file)

    content = extract_text(path)
    actors: list[str] = args.actors
    patterns: list[str] = args.patterns

    if args.cover:
        cover = extract_text(path, 0).split("intro")[0].split("Intro")[0]
        actors.extend(get_person_entities(cover))

    content = anonymize(content, actors, patterns)
    content = anonymize_dates(content)


if __name__ == "__main__":
    __main()
