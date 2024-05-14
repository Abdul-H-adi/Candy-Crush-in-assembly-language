## Candy Crush Clone - Assembly

This project is an implementation of a Candy Crush-style game written entirely in assembly language, specifically for the DOS environment. It utilizes video and keyboard interrupts to manage game mechanics and render the game board.

### Features
- **Text-mode graphics**: The game is rendered using ASCII characters in text mode, allowing for a nostalgic experience on systems that support DOS.
- **Mouse and keyboard input**: Players can use the mouse to select candies and swap them. Keyboard interrupts are used to handle other game controls.
- **Game logic**: Includes logic to handle candy swaps, match detection, and random candy generation after matches are cleared.
- **Score tracking**: The game tracks the player's score based on the number of candies matched and provides feedback on remaining moves.

### Implementation Details
- **Video Mode Handling**: The game sets and restores video modes, handles screen clearing, and cursor positioning using BIOS interrupts.
- **Mouse Handling**: Utilizes interrupt 33h for mouse input, capturing coordinates and button states to determine player actions.
- **Random Number Generation**: Implements a simple random number generator to fill the game board and replace matched candies.
- **Match Detection**: Includes procedures to check for horizontal and vertical matches and to clear matched candies from the board.
- **Score and Move Updates**: Updates and displays scores and remaining moves after each action, adjusting the game state accordingly.

### Game Mechanics
- Players swap adjacent candies to form horizontal or vertical lines of three or more matching candies.
- Matches are cleared, and the above candies fall down with new candies generated randomly at the top.
- The objective is to achieve a target score within a limited number of moves.

### How to Run
This game is intended to be run in a DOS environment. It can be compiled using an assembler that supports 8086/8088 assembly language (such as TASM or MASM) and executed on any DOS-compatible machine or emulator.
