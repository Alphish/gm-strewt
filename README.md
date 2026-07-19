<p align="center">
    <img src="Logo.png" alt="Strewt Logo">
</p>

# Strewt

**Strewt** - or the String Reading & Writing library - provides utilities for reading and writing text in GameMaker. To keep expensive string copying and combining to a minimum, both reading and writing use GM buffers under the hood. While they may not be as efficient as a well-written dedicated implementation - let alone an extension - they should perform reasonably well for a general-purpose solution and work on any GM supported platform.

## Installation

The latest Strewt package version has been developed on **GameMaker 2026.0 LTS**. It may not work correctly on older GM versions.

1. Download the Local Package YYMPS file: [Strewt.GMS2.1.0.0.yymps](https://github.com/Alphish/gm-strewt/releases/download/GMS2.1.0.0/Strewt.GMS2.1.0.0.yymps)
2. Follow the [GameMaker manual instructions](https://manual.gamemaker.io/monthly/en/#t=IDE_Tools%2FLocal_Asset_Packages.htm) to import the package; import all the assets.
3. The Strewt functionality should be ready to use!

## Guides

You can find out more about processing text with Strewt in respective guides:

- [Reading guide](/Docs/Reading/00-Overview.md), covering the following topics, among others:
    - processing various kinds of text with the **Strewt reader**
    - **Strewt patterns** representing more complex bits of text (such as number or string literals)
    - **Strewt parser base** for building custom format parsers that can split work across many frames
- [Writing guide](/Docs/Writing/00-Overview.md), covering the following topics, among others:
    - writing text with **Strewt writer**
    - **Strewt formatter base** for building custom entity formatters that can split work across many frames
