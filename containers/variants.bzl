"""
Variant builds of the source code.
"""
VARIANTS = [
    {
        "name": "default",
        "arguments": "",
    },
    {
        "name": "bots",
        "arguments": "-D BUILD_PLAYERBOTS=ON -D BUILD_AHBOT=ON",
    },
]
