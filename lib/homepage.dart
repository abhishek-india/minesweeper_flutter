// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bomb.dart';
import 'numberbox.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // grid variables
  int numberOfSquares = 9 * 9;
  int numberInEachRow = 9;

  int numberOfWins = 0;
  int numberOfLose = 0;
  void resetWinslose() {
    setState(() {
      numberOfLose=0;
      numberOfWins=0;
    });
  }

  // [ number of bombs around , revealed = true / false ]
  var squareStatus = [];

  final List<int> bombLocation=[];
  bool bombsRevealed = false;
  Random random =Random();

  @override
  void initState() {
    super.initState();
  
    // initially, each square has 0 bombs around, and is not revealed
    for (int i = 0; i < numberOfSquares; i++) {
      squareStatus.add([0, false]);
    }

    
    //bomb location
    int noOfBomb=random.nextInt(6)+5;
    for(int i=0;i<noOfBomb;i++){
      bombLocation.add(random.nextInt(81));
    }

    scanBombs();
  }

  void restartGame() {
    setState(() {
      bombsRevealed = false;
      for (int i = 0; i < numberOfSquares; i++) {
        squareStatus[i][1] = false;
      }

    //reset bomb locations
    bombLocation.clear();
    int noOfBomb=random.nextInt(11)+5;
    for(int i=0;i<noOfBomb;i++){
      bombLocation.add(random.nextInt(81));
    }

    });
  }

  void revealBoxNumbers(int index) {
    // reveal current box if it is a number: 1,2,3 etc
    if (squareStatus[index][0] != 0) {
      setState(() {
        squareStatus[index][1] = true;
      });
    }

    // if current box is 0
    else if (squareStatus[index][0] == 0) {
      // reveal current box, and the 8 surrounding boxes, unless you're on a wall
      setState(() {
        // reveal current box
        squareStatus[index][1] = true;

        // reveal left box (unless we are currently on the left wall)
        if (index % numberInEachRow != 0) {
          // if next box isn't revealed yet and it is a 0, then recurse
          if (squareStatus[index - 1][0] == 0 &&
              squareStatus[index - 1][1] == false) {
            revealBoxNumbers(index - 1);
          }

          // reveal left box
          squareStatus[index - 1][1] = true;
        }

        // reveal top left box (unless we are currently on the top row or left wall)
        if (index % numberInEachRow != 0 && index >= numberInEachRow) {
          // if next box isn't revealed yet and is a 0, then recurse
          if (squareStatus[index - 1 - numberInEachRow][0] == 0 &&
              squareStatus[index - 1 - numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1 - numberInEachRow);
          }

          squareStatus[index - 1 - numberInEachRow][1] = true;
        }

        // reveal top box (unless we are on the top row)
        if (index >= numberInEachRow) {
          // if next box isn't revealed yet and is a 0, then recurse
          if (squareStatus[index - numberInEachRow][0] == 0 &&
              squareStatus[index - numberInEachRow][1] == false) {
            revealBoxNumbers(index - numberInEachRow);
          }

          squareStatus[index - numberInEachRow][1] = true;
        }

        // reveal top right box (unless we are on the top row or the right wall)
        if (index >= numberInEachRow &&
            index % numberInEachRow != numberInEachRow - 1) {
          // if next box isn't revealed yet and is a 0, then recurse
          if (squareStatus[index + 1 - numberInEachRow][0] == 0 &&
              squareStatus[index + 1 - numberInEachRow][1] == false) {
            revealBoxNumbers(index + 1 - numberInEachRow);
          }

          squareStatus[index + 1 - numberInEachRow][1] = true;
        }

        // reveal right box (unless we are on the right wall)
        if (index % numberInEachRow != numberInEachRow - 1) {
          // if next box isn't revealed yet and is a 0, then recurse
          if (squareStatus[index + 1][0] == 0 &&
              squareStatus[index + 1][1] == false) {
            revealBoxNumbers(index + 1);
          }

          squareStatus[index + 1][1] = true;
        }

        // reveal bottom right box (unless we are on the bottom row or the right wall)
        if (index < numberOfSquares - numberInEachRow &&
            index % numberInEachRow != numberInEachRow - 1) {
          // if next box isn't revealed yet and is a 0, then recurse
          if (squareStatus[index + 1 + numberInEachRow][0] == 0 &&
              squareStatus[index + 1 + numberInEachRow][1] == false) {
            revealBoxNumbers(index + 1 + numberInEachRow);
          }

          squareStatus[index + 1 + numberInEachRow][1] = true;
        }

        // reveal bottom box (unless we are on the bottom row)
        if (index < numberOfSquares - numberInEachRow) {
          // if next box isn't revealed yet and is a 0, then recurse
          if (squareStatus[index + numberInEachRow][0] == 0 &&
              squareStatus[index + numberInEachRow][1] == false) {
            revealBoxNumbers(index + numberInEachRow);
          }

          squareStatus[index + numberInEachRow][1] = true;
        }

        // reveal bottom left box (unless we are on the bottom row or the left wall)
        if (index < numberOfSquares - numberInEachRow &&
            index % numberInEachRow != 0) {
          // if next box isn't revealed yet and is a 0, then recurse
          if (squareStatus[index - 1 + numberInEachRow][0] == 0 &&
              squareStatus[index - 1 + numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1 + numberInEachRow);
          }

          squareStatus[index - 1 + numberInEachRow][1] = true;
        }
      });
    }
  }



  void scanBombs() {
    for (int i = 0; i < numberOfSquares; i++) {
      // there are no bombs around initially
      int numberOfBombsAround = 0;

      /*

      check each square to see if it has bombs surrounding it,
      there are 8 surrounding boxes to check

      */

      // check square to the left, unless it is in the first column
      if (bombLocation.contains(i - 1) && i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }

      // check square to the top left, unless it is in the first column or first row
      if (bombLocation.contains(i - 1 - numberInEachRow) &&
          i % numberInEachRow != 0 &&
          i >= numberInEachRow) {
        numberOfBombsAround++;
      }

      // check square to the top, unless it is in the first row
      if (bombLocation.contains(i - numberInEachRow) && i >= numberInEachRow) {
        numberOfBombsAround++;
      }

      // check square to the top right, unless it is in the first row or last column
      if (bombLocation.contains(i + 1 - numberInEachRow) &&
          i >= numberInEachRow &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }

      // check square to the right, unless it is in the last column
      if (bombLocation.contains(i + 1) &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }

      // check square to the bottom right, unless it is in the last column or last row
      if (bombLocation.contains(i + 1 + numberInEachRow) &&
          i % numberInEachRow != numberInEachRow - 1 &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      }

      // check square to the bottom, unless it is in the last row
      if (bombLocation.contains(i + numberInEachRow) &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      }

      // check square to the bottom left, unless it is in the last row or first column
      if (bombLocation.contains(i - 1 + numberInEachRow) &&
          i < numberOfSquares - numberInEachRow &&
          i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }

      // add total number of bombs around to square status
      setState(() {
        squareStatus[i][0] = numberOfBombsAround;
      });
    }
  }

  void playerLost() {
    numberOfLose+=1;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[800],
            title: Center(
              child: Text(
                'YOU LOST!',
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              MaterialButton(
                  color: Colors.grey[100],
                  onPressed: () {
                    restartGame();
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.replay))
            ],
          );
        });
  }

  void playerWon() {
    numberOfWins+=1;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[700],
            title: Center(
              child: Text(
                'Y O U  W I N !',
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              Center(
                child: MaterialButton(
                  onPressed: () {
                    restartGame();
                    Navigator.pop(context);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        color: Colors.grey[300],
                        child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(Icons.replay, size: 30))),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void checkWinner() {
    // check how many boxes yet to reveal
    int unrevealedBoxes = 0;
    for (int i = 0; i < numberOfSquares; i++) {
      if (squareStatus[i][1] == false) {
        unrevealedBoxes++;
      }
    }

    // if this number is the same as the number of bombs, then player WINS!
    if (unrevealedBoxes == bombLocation.length) {
      playerWon();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 12,
        title: const Text(
          'M I N E S W E E P E R',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            
          ),
          ),
        backgroundColor: Colors.grey[200],
        centerTitle: true,

         systemOverlayStyle: SystemUiOverlayStyle(
         // Status bar color
          statusBarColor: Colors.grey[200], 
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),

        ),


      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // const SizedBox(height:40),


        // WINS ans LOSE
        Container(
            height: 150,
            //color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // display number of wins
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(numberOfWins.toString(),
                        style: TextStyle(fontSize: 40)),
                    Text('W I N S'),
                  ],
                ),

                // button to refresh the game
                GestureDetector(
                  onTap: resetWinslose,
                  child: Card(
                    child: Icon(Icons.refresh, color: Colors.white, size: 40),
                    color: Colors.grey[700],
                  ),
                ),

                // display loses
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(numberOfLose.toString(), style: TextStyle(fontSize: 40)),
                    Text('L O S E'),
                  ],
                ),
              ],
            ),
          ),



          // grid
          Expanded(
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: numberOfSquares,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numberInEachRow),
                itemBuilder: (context, index) {
                  if (bombLocation.contains(index)) {
                    return MyBomb(
                      revealed: bombsRevealed,
                      function: () {
                        setState(() {
                          bombsRevealed = true;
                        });
                        playerLost();
                        // player tapped the bomb, so player loses
                      },
                    );
                  } else {
                    return MyNumberBox(
                      child: squareStatus[index][0],
                      revealed: squareStatus[index][1],
                      function: () {
                        // reveal current box
                        revealBoxNumbers(index);
                        checkWinner();
                      },
                    );
                  }
                }),
          ),


        // STATS
          Container(
            height: 150,
            //color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // display number of bombs
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(bombLocation.length.toString(),
                        style: TextStyle(fontSize: 40)),
                    Text('B O M B'),
                  ],
                ),

                // button to refresh the game
                GestureDetector(
                  onTap: restartGame,
                  child: Card(
                    child: Icon(Icons.refresh, color: Colors.white, size: 40),
                    color: Colors.grey[700],
                  ),
                ),

                // display time taken
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('0', style: TextStyle(fontSize: 40)),
                    Text('T I M E'),
                  ],
                ),
              ],
            ),
          ),





          // branding
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Text('D E V E L O P E D  B Y  A B H I S H E K'),
          )
        ],
      ),
    );
  }
}
