import 'dart:io';
import 'dart:mirrors'; //for symbols
import 'dart:collection'; //for Queue
//@@@@@@@@@@@@@@@@@@@@@ REPEATING CODE SEGMENT @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

int input() {
  // 1. Read the input as a String
  print("Enter your choice:");
  String? input = stdin.readLineSync();
  // 2. Parse the String into an Integer
  // Use int.tryParse if you want to handle invalid non-numeric input safely
  int choice = int.parse(input!);
  return (choice);
}

//########################################################################
//@@@@@@@@@@@@@@ VARIABLES EXAMPLE @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//#######################################################################

void inttype() {
  print(
    "\tInteger Data Type can be in Easy words called Whole Numbers.\n\tCan be up to 64-bit.",
  );
  int age = 43;
  print("Code at Line 20 - 27 is an Example of Integer Data Type\n");
  print("The Integer Declared here is age with value $age\n");
}

void doubletype() {
  print(
    "\tDouble Data Type is Equivalent to float type in python. Or in Simple terms floating-point decimal numbers with 64-bit precision.\n",
  );
  double marks = 87.34;
  print("Code at Line 30 - 37 is an Example of Double Data Type\n");
  print("The Double Declared here is Marks with value $marks\n");
}

void numtype() {
  print(
    "\tA parent type for both int and double. Useful when a variable might hold either. for Example Distance, temperture, height which can be whole and sometimes need to be Float",
  );
  num distance = 45;
  print("Code at Line 38 - 45 is an Example of Num Data Type\n");
  print("The num type Declared in this is Distance with Value $distance KM\n");
}

void string() {
  print(
    "String Data Type Represents text as a sequence of UTF-16 characters. You can use single, double, or even triple quotes for multi-line text.",
  );
  String single = 'This is a single line String';
  String multi = '''This
  is
  a 
  Multiline
  String''';
  print(multi);
  print("The String Declared here is single with value $single\n");
  print("This is How a String Data Type Works\n");
  print("The Example for the String Data Type is at Line 48 - 60\n");
}

void boolean() {
  print(
    "Boolean Data type is a Binary Data Type. It is used to Represent TRUE or FALSE values ",
  );
  bool status = false;
  if (status = true) {
    print(
      "The bool value Declared here is status with value Pass in the form $status\n",
    );
  } else {
    print(
      "The bool value Declared here is Statue with value Fail in the form $status\n",
    );
  }
  print("This is How a Bool Value Works\n");
  print("The Example for the Bool Data Type is at Line 63 - 79\n");
}

void variabletype() {
  do {
    print(
      "\tVariables are Containers Used to Hold Data in Computer Programmes. It is of various types based on what functionality is needed.\n\n\t\t\t1. Integer\n\t\t\t2.Double\n\t\t\t3.Num type \n\t\t\t4.String \n\t\t\t5.Boolean \n\t\t\t6.Move Back \n\t\t\t7.Exit",
    );
    int option = input();

    switch (option) {
      case 1:
        inttype();
        break;
      case 2:
        doubletype();
        break;
      case 3:
        numtype();
        break;
      case 4:
        string();
        break;
      case 5:
        boolean();
        break;
      case 6:
        mainmenu();
        break;
      case 7:
        exit(0);
      default:
        print('Invalid choice. Please enter a number from 1 to 9.');
        break;
    }
  } while (true); // Loop indefinitely until the user chooses to exit
}

//############################################################################
//@@@@@@@@@@@@@@ MODERN DATA TYPES @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//############################################################################

void dynamictype() {
  print(
    "\tThe dynamic type disables static type checking. A variable marked dynamic can change its type during the program's execution. Use this only when you truly don't know the type (e.g., parsing complex JSON). dart",
  );
  dynamic value = 10; // Starts as an int
  print("Right Now it is of type int With Value $value\n");
  value = "Hello"; // Changes to a String (No Error)
  print("Now it is of type String With Value $value\n");
  value = true; // Changes to a bool (No Error)
  print("Finally it is of type Boolean With Value $value\n");
  print("This is how the Dynamic Type Works\n");
  print("The Example for the Dynamic Data Type is at Line 120 - 132\n");
}

//@@@@@@@@@@@@@@@@@@@@@@@ Objects Examples @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// 1. THE CLASS (The Blueprint)
class SmartDevice {
  String name;
  bool _isOn = false; // Private variable (starts with _)
  int _brightness = 0; // Private variable

  // CONSTRUCTOR: Initializes the name when the object is created
  SmartDevice(this.name);

  // 2. SETTER: Controls how data is updated
  // It includes logic to prevent invalid data (brightness can't exceed 100)
  set brightness(int value) {
    if (value < 0) {
      _brightness = 0;
    } else if (value > 100) {
      _brightness = 100; // Cap it at 100
      print("Warning: Max brightness is 100!");
    } else {
      _brightness = value;
    }
  }

  // 3. GETTER: Controls how data is read
  // It formats the data before giving it to the user
  int get brightness => _brightness;

  String get status => _isOn ? "ON" : "OFF";

  // 4. METHODS: Behaviors of the object
  void togglePower() {
    _isOn = !_isOn;
    print("$name is now $status.");
  }
}

void object() {
  print(
    "\t\tObject is the root class for all Dart classes except Null. Unlike dynamic, you cannot call methods on an Object that the compiler doesn't recognize.\n\t\t\t\tObject: Cannot be null.\n\t\t\t\tObject?: Can be any object or null",
  );
  // Creating Objects (Instances)
  var lamp = SmartDevice("Living Room Lamp");
  var tv = SmartDevice("Bedroom TV");

  // Using the SETTER
  lamp.brightness = 150; // This triggers the logic to cap it at 100

  // Using the GETTER
  print("${lamp.name} brightness level: ${lamp.brightness}%");

  // Using Methods
  lamp.togglePower();

  // Putting Objects in a List
  List<SmartDevice> homeDevices = [lamp, tv];

  print("\n--- Current Home Status ---");

  // 6. FOR-EACH LOOP: Iterating through our objects
  homeDevices.forEach((device) {
    print(
      "Device: ${device.name} | Status: ${device.status} | Light: ${device.brightness}%",
    );
  });
  print("\nThis is how the Object Type Works\n");
  print("The Example for the Object Type is at Line 171 - 200\n");
}

//@@@@@@@@@@@@@@@ Object Section over @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

void vartype() {
  print(
    "While not a 'type' itself, var tells Dart to look at the assigned value and lock in that type forever. It provides type safety without the verbal 'noise' of writing out the class name.\n",
  );
  var score = 50; // Dart infers this as 'int'
  //score = "Win"; // Error: A value of type 'String' can't be assigned to 'int'.
  print(
    "   The var type declared here is score with value $score\n\tAssigning the value 'win' generates error",
  );
  print("This is how the Var Type Works\n");
  print("The Example for the Var Type is at Line 203 - 215\n");
}

void runes() {
  print(
    "Strings in Dart are sequences of UTF-16 code units. Runes allow you to access the UTF-32 code points, which is necessary for representing emojis or special mathematical symbols.\n",
  );
  var heart = '\u2665'; // Standard Unicode
  var smile = '\u{1f600}'; // Extended Unicode (Emoji)
  print("the Runes Declared here are as below");
  print(heart); // ♥
  print(smile); // 😀
  print("This is how the Runes Type Works\n");
  print("The Example for the Runes Type is at Line 218 - 229\n");
}

//@@@@@@@@@@@@@@@@@ SYMBOLS @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

class Robot {
  void sayHello() => print("Beep Boop!");
}

void symbols() {
  print(
    "A Symbol represents an identifier (like a function or variable name) used in the Dart program. They are primarily used in Reflection (mirrors) to refer to code elements by name without them being minified or changed during compilation.\n",
  );
  var myRobot = Robot();

  // Reflecting on the instance
  InstanceMirror mirror = reflect(myRobot);

  // Invoking a method using a Symbol
  mirror.invoke(#sayHello, []);
  print(myRobot);
  print("This is how the Symbols Type Works\n");
  print("The Example for the Symbols Type is at Line 232 - 252\n");
}

//@@@@@@@@@@@@@@@@ Symbols Over @@@@@@@@@@@@@@@@@@@@@@@@@@@@

void nulltype() {
  print(
    " With Dart’s Sound Null Safety, types are non-nullable by default. To allow a variable to hold no value, you must use the ? operator.",
  );
  //int age = null;  // Error: Constant expression is null.
  int? age = null; // OK: The '?' makes it a nullable type.
  print(age);
  print("This is how the Null Type Works\n");
  print("The Example for the Null Type is at Line 255 - 265\n");
}

//@@@@@@@@@@@ Void All Use Cases @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// 1. Standard Function: Just performs an action and exits
void printGreeting(String name) {
  print("Hello, $name!");
}

class Logger {
  // 2. Class Method: Updates the internal state of an object
  void logAction(String action) {
    print("[LOG]: $action performed at ${DateTime.now()}");
  }
}

// 3. Asynchronous Function: Returns a Future that completes with no value
Future<void> saveSettings() async {
  print("Saving to database...");
  await Future.delayed(Duration(seconds: 1));
  print("Settings saved!");
}

void voidtype() async {
  // 4. Callback Usage: void is used as a function type for listeners
  void Function() myCallback = () {
    print("The button was clicked!");
  };

  // Executing the examples
  printGreeting("Alice");

  var myLogger = Logger();
  myLogger.logAction("Login");

  myCallback();

  await saveSettings();

  print("All tasks finished.");
}

//@@@@@@@@@@@@@ Void Use Cases End @@@@@@@@@@@@@@@@@@@@@@@@@@@@@

void modernDatatypes() {
  print(
    "\tModern Data Types are Special Data Types Specifically Desighned for the Complexity of Modern Codes. They are also Called Special types. Special Types handle scenarios where standard data types (like int or String) are too restrictive or where you need to manage memory and identity specifically. \n",
  );

  do {
    print(
      "\n\t\t\t 1. Dynamic Type. \n\t\t\t 2. Object Type. \n\t\t\t 3. Var Type \n\t\t\t 4. Runes. \n\t\t\t 5. Symbols. \n\t\t\t 6. Null Type. \n\t\t\t 7. Void \n\t\t\t 8. Move Back \n\t\t\t 9. Exit ",
    );
    print("Enter your choice:");
    int option = input();
    switch (option) {
      case 1:
        dynamictype();
        break;
      case 2:
        object();
        break;
      case 3:
        vartype();
        break;
      case 4:
        runes();
        break;
      case 5:
        symbols();
        break;
      case 6:
        nulltype();
        break;
      case 7:
        voidtype();
        break;
      case 8:
        mainmenu();
        break;
      case 9:
        exit(0);
    }
  } while (true);
}

//############################################################################
//@@@@@@@@@@@@@@ Collection @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//#############################################################################

void list() {
  print(
    "\tA List (often called an array in other languages) is an ordered group of items where each item has a specific position (index).\n\t\t\tDuplicate items: Allowed.\n\t\t\tAccess: By index (starting at 0).\n\t\t\t Best for: Displaying a sequence of elements, like a contact list or message history. ",
  );
  // Creating a List
  List<String> fruits = ['Apple', 'Banana', 'Apple']; // Duplicates okay

  fruits.add('Orange'); // Add to end
  print(fruits[1]); // Access by index (Output: Banana)
  print(fruits); // [Apple, Banana, Apple, Orange]
  print("This is how the List Type Works\n");
  print("The Example for the List Type is at Line 350 - 362\n");
}

void sets() {
  print(
    "\t2. Set (Unique Collection)\n\t\tA Set is an unordered collection where every element must be unique. \n\n\t\t\t\tDuplicate items: Not allowed (ignored if added).\n\t\t\t\tAccess: No index access; typically used for checking membership.\n\t\t\t\tBest for: Storing distinct IDs, unique categories, or selected tags.",
  );
  // Creating a Set
  Set<int> uniqueNumbers = {1, 2, 3}; // any second '3' is ignored

  uniqueNumbers.add(4);
  print(uniqueNumbers.contains(2)); // Check membership (Output: true)
  print(uniqueNumbers); // {1, 2, 3, 4}
  print("This is how the Set Type Works\n");
  print("The Example for the Set Type is at Line 365 - 375\n");
}

void map() {
  print(
    "\t3. Map (Key-Value Pairs)\n\t\tA Map (similar to a dictionary or hash table) associates unique keys with specific values.\n\n\t\t\t\tKeys: Must be unique.\n\t\t\t\tValues: Can be duplicates.\n\t\t\t\tBest for: Configuration data, looking up values by a label, or representing JSON-like data.",
  );
  // Creating a Map <Key, Value>
  Map<String, String> userScores = {'Alice': 'A', 'Bob': 'B'};

  userScores['Charlie'] = 'A'; // Adding a new pair
  print(userScores['Alice']); // Look up by key (Output: A)
  print(userScores); // {Alice: A, Bob: B, Charlie: A}
  print("This is how the Map Type Works\n");
  print("The Example for the Map Type is at Line 378 - 388\n");
}

void queue() {
  print(
    "\t4. Queue (FIFO/LIFO)\n\t\tA Queue is a collection that can be manipulated at both ends. It is ideal for First-In, First-Out (FIFO) processing.\n\n\t\t\t\tRequirement: Requires import 'dart:collection';.\n\t\t\t\tBest for: Order processing or buffer management.\n\n\t\tFIFO\n\t\t\tThink of a movie theatre line: the first person to get in line is the first person to get a ticket. In coding, this is a standard Queue.\n\t\t\tLogic: Add to the back (addLast), remove from the front (removeFirst).",
  );
  Queue<String> printerRocket = Queue();

  // Adding items to the queue (Enqueuing)
  printerRocket.addLast("Document_1.pdf");
  printerRocket.addLast("Photo_2.png");
  printerRocket.addLast("Invoice_3.docx");

  // Processing items (Dequeuing)
  while (printerRocket.isNotEmpty) {
    print("Printing: ${printerRocket.removeFirst()}");
  }
  // Output: Document_1, then Photo_2, then Invoice_3

  print(
    "2. LIFO / LILO (Last-In, First-Out / Last-In, Last-Out)\n\t\tThink of a stack of plates: the last plate you put on top is the first one you pick up. In coding, this is called a Stack.\n\t\t\tLogic: Add to the top (addLast), remove from the top (removeLast).",
  );
  Queue<String> browserHistory = Queue();

  // Adding pages (Pushing)
  browserHistory.addLast("google.com");
  browserHistory.addLast("flutter.dev");
  browserHistory.addLast("dart.dev");

  // Going "Back" (Popping)
  while (browserHistory.isNotEmpty) {
    print("Navigating back from: ${browserHistory.removeLast()}");
  }
  // Output: dart.dev, then flutter.dev, then google.com
  print("This is how the Queue Type Works\n");
  print("The Example for the Queue Type is at Line 391 - 425\n");
}

//@@@@@@@@@@@@@@@@ Linked List @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

base class MyEntry extends LinkedListEntry<MyEntry> {
  final String text;
  MyEntry(this.text);
}

void linkedlist() {
  print(
    "\t2. LinkedList\n\t\tUnlike a List, a LinkedList is a specialized sequence of elements where each item knows its next and previous neighbour. To use it, your objects must extend LinkedListEntry.",
  );
  var list = LinkedList<MyEntry>();
  list.addAll([MyEntry('A'), MyEntry('B')]);
  print("Current LinkedList: ${list.map((entry) => entry.text).join(', ')}");
  list.first.insertAfter(MyEntry('C')); // Insert 'C' after 'A'
  print("Updated LinkedList: ${list.map((entry) => entry.text).join(', ')}");
  print("This is how the LinkedList Type Works\n");
  print("The Example for the LinkedList Type is at Line 430 - 442\n");
}

void collection() {
  print(
    "\tDart collections are objects that group multiple elements together.\n The three primary types are List, Set, and Map.",
  );

  do {
    print(
      "\n\t\t\t1. Lists\n\t\t\t2. Sets\n\t\t\t3. Maps\n\t\t\t4. Queue\n\t\t\t\t5. Linked List\n\t\t\t\t6. Move Back\n\t\t\t7. Exit",
    );
    int option = input();
    switch (option) {
      case 1:
        list();
        break;
      case 2:
        sets();
        break;
      case 3:
        map();
        break;
      case 4:
        queue();
        break;
      case 5:
        linkedlist();
        break;
      case 6:
        mainmenu();
        break;
      case 7:
        return;
      default:
        print('Invalid choice. Please enter a number from 1 to 7.');
        break;
    }
  } while (true);
}
//############################################################################
//@@@@@@@@@@@@@@@@@@@@@@@ Adding Data to Collection @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//############################################################################

void add() {
  print(
    "\t1. Add() option\n\t\tThe add() method is a straightforward way to add a single element to the end of a List or Set. It’s simple and efficient for adding one item at a time.",
  );
  List<String> colors = ['Red', 'Green'];
  colors.add('Blue'); // Adds 'Blue' to the end of the list
  print(colors); // Output: [Red, Green, Blue]
  print("This is how the Add() Method Works\n");
  print("The Example for the Add() Method is at Line 480 - 488\n");
}

void addall() {
  print(
    "\t2. AddAll() option\n\t\tThe addAll() method allows you to add multiple elements to a List or Set in one operation. It takes an Iterable (like another List) and appends all of its elements to the collection.",
  );
  List<String> colors = ['Red', 'Green'];
  colors.addAll(['Blue', 'Yellow']); // Adds multiple colors at once
  print(colors); // Output: [Red, Green, Blue, Yellow]
  print("This is how the AddAll() Method Works\n");
  print("The Example for the AddAll() Method is at Line 490 - 498\n");
}

void insert() {
  print(
    "\t3. Insert() option\n\t\tThe insert() method is used to add an element at a specific index in a List. It shifts the existing elements to the right to make space for the new item.",
  );
  List<String> colors = ['Red', 'Green'];
  colors.insert(1, 'Blue'); // Inserts 'Blue' at index 1
  print(colors); // Output: [Red, Blue, Green]
  print("This is how the Insert() Method Works\n");
  print("The Example for the Insert() Method is at Line 500 - 510\n");
}

void insertall() {
  print(
    "\t4. InsertAll() option\n\t\tThe insertAll() method allows you to insert multiple elements at a specific index in a List. It shifts the existing elements to the right to accommodate the new items.",
  );
  List<String> colors = ['Red', 'Green'];
  colors.insertAll(1, ['Blue', 'Yellow']); // Inserts multiple colors at index 1
  print(colors); // Output: [Red, Blue, Yellow, Green]
  print("This is how the InsertAll() Method Works\n");
  print("The Example for the InsertAll() Method is at Line 512 - 522\n");
}

void mapmethods() {
  print(
    "\t5. Map Specific Methods (putIfAbsent, update)\n\t\tMaps have unique methods for adding or updating key-value pairs. putIfAbsent adds a new pair only if the key doesn’t already exist, while update modifies the value for an existing key.",
  );
  Map<String, String> userScores = {'Alice': 'A', 'Bob': 'B'};

  // Using putIfAbsent
  userScores.putIfAbsent('Charlie', () => 'A'); // Adds Charlie with score A
  userScores.putIfAbsent(
    'Alice',
    () => 'C',
  ); // Does nothing since Alice already exists

  // Using update
  userScores.update('Bob', (existing) => 'A+'); // Updates Bob's score to A+
  print(userScores); // Output: {Alice: A, Bob: A+, Charlie: A}
  print("This is how the Map Specific Methods Works\n");
  print("The Example for the Map Specific Methods is at Line 525 - 540\n");
}

void spreadoperator() {
  print(
    "\t6. Spread Operator\n\t\tThe spread operator (...) allows you to insert all elements of a collection into another collection. It’s a concise way to combine lists or sets without needing to call addAll().",
  );
  List<String> colors1 = ['Red', 'Green'];
  List<String> colors2 = ['Blue', 'Yellow'];
  List<String> allColors = [...colors1, ...colors2]; // Combines both lists
  print(allColors); // Output: [Red, Green, Blue, Yellow]
  print("This is how the Spread Operator Works\n");
  print("The Example for the Spread Operator is at Line 542 - 553\n");
}

void addingelemets() {
  print(
    "\tAdding data to a collection in Dart can be done using various methods depending on the type of collection you are working with. Here are some common techniques for adding data to Lists, Sets, and Maps:",
  );

  do {
    print(
      "\n\t\t\t1. Add() option\n\t\t\t2. Addall() option\n\t\t\t3. Insert() option\n\t\t\t4. InsertAll() option\n\t\t\t5. Map Specific Methods (putIfAbsent, update)\n\t\t\t6.Spread Operator\n\t\t\t7.Move Back\n\t\t\t8. Exit",
    );
    int option = input();
    switch (option) {
      case 1:
        add();
        break;
      case 2:
        addall();
        break;
      case 3:
        insert();
        break;
      case 4:
        insertall();
        break;
      case 5:
        mapmethods();
        break;
      case 6:
        spreadoperator();
        break;
      case 7:
        mainmenu();
        break;
      case 8:
        exit(0);
    }
  } while (true);
}

//############################################################################
//@@@@@@@@@@@@@@ Removing data from set @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//#############################################################################

void removingDatafromset() {
  print(
    "\tRemoving data from a Set in Dart can be done using several methods, depending on your specific needs. Here are some common techniques for removing elements from a Set:",
  );

  do {
    print(
      "\n\t\t\t1. Remove() method\n\t\t\t2. RemoveWhere() method\n\t\t\t3. Clear() method\n\t\t\t4. Remove At\n\t\t\t5.Remove Last\n\t\t\t6. Remove Range\n\t\t\t7. Truncate\n\t\t\t Move Back\n\t\t\t8. Exit",
    );
    int option = input();
    switch (option) {
      case 1:
        print(
          "\t1. Remove() method\n\t\tThe remove() method is used to delete a specific element from a Set. It returns true if the element was successfully removed, and false if the element was not found in the Set.",
        );
        Set<String> colors = {'Red', 'Green', 'Blue'};
        bool removed = colors.remove('Green'); // Removes 'Green'
        print(removed); // Output: true
        print(colors); // Output: {Red, Blue}
        print("This is how the Remove() Method Works\n");
        print("The Example for the Remove() Method is at Line 608 - 616\n");
        break;
      case 2:
        print(
          "\t2. RemoveWhere() method\n\t\tThe removeWhere() method allows you to remove all elements that satisfy a certain condition defined by a callback function.",
        );
        Set<int> numbers = {1, 2, 3, 4, 5};
        numbers.removeWhere(
          (number) => number % 2 == 0,
        ); // Removes even numbers
        print(numbers); // Output: {1, 3, 5}
        print("This is how the RemoveWhere() Method Works\n");
        print(
          "The Example for the RemoveWhere() Method is at Line 618 - 626\n",
        );
        break;
      case 3:
        print(
          "\t3. Clear() method\n\t\tThe clear() method removes all elements from the Set, leaving it empty.",
        );
        Set<String> animals = {'Cat', 'Dog', 'Bird'};
        animals.clear(); // Empties the set
        print(animals); // Output: {}
        print("This is how the Clear() Method Works\n");
        print("The Example for the Clear() Method is at Line 630 - 638\n");
        break;
      case 4:
        print(
          "\t4. Remove At\n\t\tThe removeAt() method is not available for Sets since they are unordered collections. However, you can convert the Set to a List to remove an element at a specific index.",
        );
        Set<String> colorsSet = {'Red', 'Green', 'Blue'};
        List<String> colorsList = colorsSet.toList();
        colorsList.removeAt(1); // Removes the element at index 1
        print(colorsList); // Output: [Red, Blue]
        print("This is how the Remove At Method Works\n");
        print("The Example for the Remove At Method is at Line 642 - 648\n");
        break;
      case 5:
        print(
          "\t5. Remove Last\n\t\tThe removeLast() method is not available for Sets since they are unordered collections. However, you can convert the Set to a List to remove the last element.",
        );
        Set<String> colorsSet = {'Red', 'Green', 'Blue'};
        List<String> colorsList = colorsSet.toList();
        colorsList.removeLast(); // Removes the last element
        print(colorsList); // Output: [Red, Green]
        print("This is how the Remove Last Method Works\n");
        print("The Example for the Remove Last Method is at Line 650 - 660\n");
        break;
      case 6:
        print(
          "\t6. Remove Range\n\t\tThe removeRange() method is not available for Sets since they are unordered collections. However, you can convert the Set to a List to remove a range of elements.",
        );
        Set<String> colorsSet = {'Red', 'Green', 'Blue', 'Yellow', 'Purple'};
        List<String> colorsList = colorsSet.toList();
        colorsList.removeRange(1, 3); // Removes elements from index 1 to 2
        print(colorsList); // Output: [Red, Purple]
        print("This is how the Remove Range Method Works\n");
        print("The Example for the Remove Range Method is at Line 662 - 672\n");
        break;
      case 7:
        print(
          "\t7. Truncate\n\t\tThe truncate() method is not available for Sets since they are unordered collections. However, you can convert the Set to a List to truncate it to a specific length.",
        );
        Set<String> colorsSet = {'Red', 'Green', 'Blue', 'Yellow', 'Purple'};
        List<String> colorsList = colorsSet.toList();
        colorsList.length = 3; // Truncates the list to the first 3 elements
        print(colorsList); // Output: [Red, Green, Blue]
        print("This is how the Truncate Method Works\n");
        print("The Example for the Truncate Method is at Line 674 - 684\n");
        break;
      case 8:
        mainmenu();
        break;
      default:
        print('Invalid choice. Please enter a number from 1 to 8.');
        break;
    }
  } while (true);
}

//############################################################################
//@@@@@@@@@@@@@@ Operators @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//############################################################################

void arithmaticoperators() {
  print("Arithmetic Operators: +, -, *, /, %, ~/ (integer division)");
  int a = 10;
  int b = 3;
  print("a + b = ${a + b}"); // Addition
  print("a - b = ${a - b}"); // Subtraction
  print("a * b = ${a * b}"); // Multiplication
  print("a / b = ${a / b}"); // Division
  print("a % b = ${a % b}"); // Modulus
  print("a ~/ b = ${a ~/ b}"); // Integer Division
  print("This is how the Arithmatic Operators Works\n");
  print("The Example for the Arithmatic Operators is at Line 700 - 710\n");
}

void assignment() {
  print("Assignment Operators: =, +=, -=, *=, /=, %=");
  int x = 5; // Assignment
  double y = 10.0;
  x += 3; // Equivalent to x = x + 3
  print("x after += 3: $x"); // Output: 8
  x -= 2; // Equivalent to x = x - 2
  print("x after -= 2: $x"); // Output: 6
  x *= 4; // Equivalent to x = x * 4
  print("x after *= 4: $x"); // Output: 24
  y /= 6; // Equivalent to x = x / 6
  print("y after /= 6: $y"); // Output: 1.6666666666666667
  x %= 3; // Equivalent to x = x % 3
  print("x after %= 3: $x"); // Output: 1
  print("This is how the Assignment Operators Works\n");
  print("The Example for the Assignment Operators is at Line 712 - 725\n");
}

void comparison() {
  print("Comparison Operators: ==, !=, >, <, >=, <=");
  int a = 5;
  int b = 10;
  print("a == b: ${a == b}"); // Equality
  print("a != b: ${a != b}"); // Inequality
  print("a > b: ${a > b}"); // Greater than
  print("a < b: ${a < b}"); // Less than
  print("a >= b: ${a >= b}"); // Greater than or equal to
  print("a <= b: ${a <= b}"); // Less than or equal to
  print("This is how the Comparison Operators Works\n");
  print("The Example for the Comparison Operators is at Line 727 - 738\n");
}

void logical() {
  print("Logical Operators: &&, ||, !");
  bool p = true;
  bool q = false;
  print("p && q: ${p && q}"); // Logical AND
  print("p || q:"); // Logical OR
  print("!p: ${!p}"); // Logical NOT
  print("!q: ${!q}"); // Logical NOT
  print("!p && !q:"); // Logical AND of negations
  print("!p || !q: ${!p || !q}"); // Logical OR of negations
  print("This is how the Logical Operators Works\n");
  print("The Example for the Logical Operators is at Line 740 - 750\n");
}

void bitwise() {
  print("Bitwise Operators: &, |, ^, ~, <<, >>");
  int a = 5; // In binary: 0101
  int b = 3; // In binary: 0011
  print("a & b: ${a & b}"); // Bitwise AND (Output: 1)
  print("a | b: ${a | b}"); // Bitwise OR (Output: 7)
  print("a ^ b: ${a ^ b}"); // Bitwise XOR (Output: 6)
  print("~a: ${~a}"); // Bitwise NOT (Output: -6)
  print("a << 1: ${a << 1}"); // Left shift (Output: 10)
  print("b >> 1: ${b >> 1}"); // Right shift (Output: 1)
  print("a << 2: ${a << 2}"); // Left shift by 2 (Output: 20)
  print("b >> 2: ${b >> 2}"); // Right shift by 2 (Output: 0)
  print("This is how the Bitwise Operators Works\n");
  print("The Example for the Bitwise Operators is at Line 760 - 770\n");
}

//############### is Examples #############################

void isbroad() {
  print(
    "1. Checking a Broad Type (Object or dynamic)\n\t\tWhen a variable is declared as Object or dynamic, its actual runtime type is unknown to the compiler, making a type check necessary and valid. ",
  );
  // Use Object or dynamic so the compiler doesn't know the exact type yet
  Object unknownValue = "Hello";

  if (unknownValue is String) {
    // This is valid! 'unknownValue' is promoted to String here.
    print("The length is ${unknownValue.length}");
  }
  print(
    unknownValue,
  ); // Still works, it's just treated as Object outside the if block
  print(
    "The value is: ${unknownValue.toString()}. toString() Method still Works even though the type is unknown",
  ); // Still works, toString() is a method on Object
  print("This is how the is Operator Works\n");
  print("The Example for the is Operator is at Line 777 - 790\n");
}

void subtypes() {
  print(
    "2. Checking Subtypes\n\t\tWhen you have a variable of a superclass type (like num) that can hold multiple subtypes (like int and double), using is to check for the specific subtype is valid and allows for type promotion.",
  );
  num number = 3.14; // Can be int or double

  if (number is int) {
    // This checks if 'number' is specifically an int
    print("The number is an integer with value $number");
  } else if (number is double) {
    // This checks if 'number' is specifically a double
    print("The number is a double with value $number");
  }
  print("This is how the is Operator Works for Subtypes\n");
  print("The Example for the is Operator with Subtypes is at Line 795 - 810\n");
}

void nullable() {
  print(
    "3. Checking Nullable Types\n\t\tWhen dealing with nullable types (e.g., String?), you can use is to check if the variable is not null and of the expected type.",
  );
  // 1. Declare a nullable String
  // The compiler doesn't know if this is a String or null at runtime
  String? name = getUsername();

  // 2. Perform the type test
  // This is VALID and necessary because 'name' might be null.
  if (name is String) {
    // Inside this block, 'name' is promoted from String? to String
    print("The name is ${name.length} characters long.");
    print(name.toUpperCase());
  } else {
    print("Name is null or not a string.");
  }
  print("This is how the is Operator Works for Nullable Types\n");
  print(
    "The Example for the is Operator with Nullable Types is at Line 815 - 830\n",
  );
}

// A simple function that simulates getting data that might be null
String? getUsername() {
  return "DartUser"; // Change to 'null' to see the else block run
}

void istypecheck() {
  print(
    "Type Test Operators are used to check the type of an object at runtime. The is operator checks if an object is of a specific type, while the is! operator checks if it is NOT of that type. The as operator is used for casting an object to a specific type.",
  );
  do {
    print(
      "\n\t1.Broad Type\n\t2.Subtypes\n\t3.Nullable Types\n\t4.Move Back\n\t5.Exit",
    );
    int option = input();
    switch (option) {
      case 1:
        isbroad();
        break;
      case 2:
        subtypes();
        break;
      case 3:
        nullable();
        break;
      case 4:
        mainmenu();
        break;
      case 5:
        exit(0);
      default:
        print('Invalid choice. Please enter a number from 1 to 5.');
        break;
    }
  } while (true);
}

//############### is! Examples #############################

void printLength(String? text) {
  // ✅ VALID: 'text' could be String or null.
  // Checking 'is! String' is a valid way to catch the null case.
  if (text is! String) {
    print("Error: The value provided is null.");
    return; // Exit early
  }

  // After the check, 'text' is automatically promoted to a non-nullable String
  print("The text length is: ${text.length}");
}

void guardclause() {
  print(
    "1. Guard Clause\n\t\tUsing is! to check for an invalid type at the start of a function can serve as a guard clause, allowing you to exit early if the input doesn't meet the expected type.This is the most common way to use is!. You check if a nullable variable is not the underlying type (meaning it is likely null).",
  );
  printLength("Hello"); // Prints: 5
  printLength(null); // Prints: Error message
  print("This is how the is! Operator Works for Guard Clauses\n");
  print(
    "The Example for the is! Operator with Guard Clauses is at Line 870- 890\n",
  );
}

void processScore(dynamic score) {
  // ✅ VALID: Since 'score' is dynamic, it could be anything (bool, String, etc.)
  // We check if it is NOT an integer before doing math.
  if (score is! int) {
    print("Invalid score type! Expected a number.");
    return;
  }

  // If it passes, we can safely treat it as an int
  print("Your score doubled is: ${score * 2}");
}

void genericdata() {
  print(
    "2. Handling Generic Data (dynamic)\n\t\tWhen receiving data from an API or a JSON map, the type is often dynamic. Using is! allows you to reject data that doesn't match your expectations.",
  );
  processScore(10); // Prints: 20
  processScore("Ten"); // Prints: Invalid score type!
  print("This is how the is! Operator Works for Generic Data\n");
  print(
    "The Example for the is! Operator with Generic Data is at Line 900 - 920\n",
  );
}

abstract class Member {}

class PremiumMember extends Member {}

class StandardMember extends Member {}

void showAd(Member user) {
  // ✅ VALID: 'user' is a Member, but could be Premium or Standard.
  // We only show ads if the user is NOT a PremiumMember.
  if (user is! PremiumMember) {
    print("Showing a 30-second advertisement...");
  } else {
    print("Thank you for being a Premium Member! No ads.");
  }
}

void subclasses() {
  print(
    "3. Filtering Subclasses in a Hierarchy\n\t\tIf you have a base class, you might want to perform an action only if an object is not a specific subclass.",
  );
  showAd(StandardMember()); // Shows ad
  showAd(PremiumMember()); // No ad
  print("This is how the is! Operator Works for Subclasses\n");
  print(
    "The Example for the is! Operator with Subclasses is at Line 920 - 945\n",
  );
}

//@@@@@@@@@@@@@@@@ as @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
// 2. casting dynamic data to a specific type is a common use case for the as operator. When you receive data that could be of any type (like from a JSON response), you can use as to cast it to the expected type after checking it with is.
void processData(dynamic rawData) {
  // ✅ VALID: rawData could be anything. We cast to int to do math.
  // If rawData is actually a String, this will throw an error (which is often intended).
  int score = rawData as int;

  print("Double score: ${score * 2}");
}

//3. Downcasting in a Class Hierarchy

abstract class Shape {}

class Circle extends Shape {
  void drawCircle() => print("Drawing a circle ○");
}

class Square extends Shape {}

void renderShape(Shape shape) {
  // If we are sure this specific part of the code only handles circles:
  // ✅ VALID: shape is declared as 'Shape', but we cast to 'Circle'
  Circle myCircle = shape as Circle;
  myCircle.drawCircle();
}

void asoperator() {
  print(
    "The as operator (type casting) triggers an unnecessary_cast warning if the compiler already knows the variable is that type. To use it correctly without warnings, you use it when you have a broad type (like Object, dynamic, or a BaseClass) and you need to treat it as a specific type to access certain properties.",
  );
  do {
    print(
      "\n\t\t\t1. Casting Object to a Specific Type\n\t\t\t2. Casting dynamic Data\n\t\t\t3. Downcasting in a Class Hierarchy\n\t\t\t4. Move Back\n\t\t\t5. Exit",
    );

    int option = input();
    switch (option) {
      case 1:
        print(
          "\n\t1. Casting Object to a Specific Type\n\t\t\tWhen you receive data as an Object (the parent of all types), you cannot access specific properties (like .length or .abs()) without casting it first.",
        );
        // Declared as Object, so the compiler only knows it's "some object"
        Object someValue = "Flutter";

        // print(someValue.length); ❌ This would cause a compile error!

        // ✅ VALID: Cast to String so we can access String properties
        var text = someValue as String;
        print("The string length is: ${text.length}");
        print("This is how the as Operator Works for Casting\n");
        print(
          "The Example for the as Operator with Casting is at Line 990 - 1000\n",
        );
        break;
      case 2:
        print(
          "\n\t2. Casting from dynamic (API/JSON style)\n\t\tWhen working with dynamic data (common with JSON), the compiler turns off type checking. Using as forces a specific type, which is safer for the rest of your code.",
        );
        processData(50); // Works fine
        // processData("50"); // Would crash at runtime, preventing silent bugs
        print("This is how the as Operator Works for Dynamic Data\n");
        print(
          "The Example for the as Operator with Dynamic Data is at Line 1005 - 1010\n",
        );
        break;
      case 3:
        print(
          "\n\t3. Downcasting in a Class Hierarchy\n\t\tThis is used when you have a general reference (like Shape) but you are certain it is a specific implementation (like Circle) and need to access its specific methods.",
        );
        Shape myShape = Circle();
        renderShape(myShape);
        print("This is how the as Operator Works for Downcasting\n");
        print(
          "The Example for the as Operator with Downcasting is at Line 1015 - 1025\n",
        );
        break;
      case 4:
        mainmenu();
        break;
      case 5:
        exit(0);
      default:
        print('Invalid choice. Please enter a number from 1 to 5.');
        break;
    }
  } while (true);
}
//

void notistypecheck() {
  print(
    "To use the is! (is-not) operator without triggering an 'unnecessary type check' warning, you need to test a variable whose type is not already guaranteed by its declaration.",
  );
  do {
    print(
      "\n\t\t\t1.Guard Clause\n\t\t\t2.Generic Data\n\t\t\t3.Subclasses in a Hierarchy\n\t\t\t4.Move Back\n\t\t\t5.Exit",
    );
    int option = input();
    switch (option) {
      case 1:
        guardclause();
        break;
      case 2:
        genericdata();
        break;
      case 3:
        subclasses();
        break;
      case 4:
        mainmenu();
        break;
      case 5:
        exit(0);
      default:
        print('Invalid choice. Please enter a number from 1 to 5.');
        break;
    }
  } while (true);
}

void typetest() {
  print("\tType Test Operators: is, is!, as");
  do {
    print(
      "\n\t\t\t1. is\n\t\t\t2. is!\n\t\t\t3. as\n\t\t\t4. Move Back\n\t\t\t5. Exit",
    );
    int option = input();
    switch (option) {
      case 1:
        istypecheck();
        break;
      case 2:
        notistypecheck();
        break;
      case 3:
        asoperator();
        break;
      case 4:
        mainmenu();
      case 5:
        exit(0);
      default:
        print('Invalid choice. Please enter a number from 1 to 3.');
        break;
    }
  } while (true);
}
//#####################################################################################
//@@@@@@@@@@@@Conditional ternary@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//#####################################################################################

void ternary() {
  print(
    "\n\t1. Standard Ternary Operator (condition ? expr1 : expr2)\n\t\tThis operator evaluates a boolean condition. If the condition is true, it returns expr1; otherwise, it returns expr2.\n\t\tIt’s a more compact alternative to an if-else statement for simple conditions.",
  );
  int age = 20;

  // Basic usage: Assigning a value based on a condition
  String status = age >= 18 ? "Adult" : "Minor";
  print(status); // Output: Adult

  // Direct use in print statements
  print(age % 2 == 0 ? "Even" : "Odd"); // Output: Even
  print("This is how the Standard Ternary Operator Works\n");
  print(
    "The Example for the Standard Ternary Operator is at Line 1100 - 1115\n",
  );
}

void nestedternary() {
  print(
    "\n\t2. Nested (Chained) Ternary Operator\n\t\tYou can nest ternary operators to handle multiple conditions in a single expression. However, this can reduce readability if overused.",
  );
  int score = 85;

  String grade = score >= 90
      ? "A"
      : score >= 80
      ? "B"
      : score >= 70
      ? "C"
      : score >= 60
      ? "D"
      : "F";
  print("Grade: $grade"); // Output: Grade: B
  print("This is how the Nested Ternary Operator Works\n");
  print("The Example for the Nested Ternary Operator is at Line 1115 - 1130\n");
}

void nullcoalescing() {
  print(
    "\n\t\tThis operator returns expr1 if it is not null; otherwise, it returns expr2. It’s commonly used to provide default values for nullable variables.",
  );
  String? username;

  // Using null-coalescing to provide a default value
  String displayName = username ?? "Guest";
  print("Welcome, $displayName!"); // Output: Welcome, Guest!
  print("This is how the Null-Coalescing Operator Works\n");
  print(
    "The Example for the Null-Coalescing Operator is at Line 1135 - 1150\n",
  );
}

void conditional() {
  print(
    "Dart provides two main types of conditional (ternary) operators to handle logic concisely: the standard ternary operator (? :) and the null-coalescing operator (??). These operators allow you to write more compact and readable code when making decisions based on conditions or handling null values.",
  );
  do {
    print(
      "\n\t\t\t1. Standard Ternary Operator (condition ? expr1 : expr2)\n\t\t\t2. Nested (Chained) Ternary Operator\n\t\t\t3. Null-Coalescing Operator (expr1 ?? expr2) \n\t\t\t4. Move Back\n\t\t\t5. Exit",
    );
    int option = input();
    switch (option) {
      case 1:
        ternary();
        break;
      case 2:
        nestedternary();
        break;
      case 3:
        nullcoalescing();
        break;
      case 4:
        mainmenu();
        break;
      case 5:
        exit(0);
      default:
        print('Invalid choice. Please enter a number from 1 to 5.');
        break;
    }
  } while (true);
}
//#############################################################################
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Cascades @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//#############################################################################

//1. Basic Method and Property Chaining
class Car {
  String? color;
  int speed = 0;
  void drive() => print('The $color car is moving at $speed km/h.');
}

//2. Null-Shorting Cascade (?..)

class Profile {
  String? username;
  void load() => print('Profile loaded for $username.');
}

//3. Nesting Cascades
class Engine {
  double? horsepower;
}

class Truck {
  String? model;
  Engine? engine;
}

//5. Complex Object Configuration (Flutter Style)
class MockPaint {
  String? color;
  double? width;
  bool? isAntiAlias;
}

void cascade() {
  print(
    "The Cascade Notation Operator (..) in Dart allows you to perform multiple operations on the same object without needing to repeat the object’s name. It’s a convenient way to chain method calls and property accesses on a single instance.",
  );
  do {
    print(
      "\n\t\t1. Basic Method and Property Chaining\n\t\t2. Null-Shorting Cascade (?..)\n\t\t3. Nesting Cascades\n\t\t4. Working with Collections\n\t\t5. Complex Object Configuration (Flutter Style) \n\t\t6. Move Back\n\t\t7. Exit",
    );
    int option = input();
    switch (option) {
      case 1:
        print(
          "\t1. Basic Method and Property Chaining\n\t\tThe cascade operator allows you to call multiple methods or set multiple properties on the same object without repeating its name. This leads to cleaner and more concise code when configuring an object.",
        );
        // All operations are performed on the same Car instance
        var myCar = Car()
          ..color = 'Blue'
          ..speed = 80
          ..drive();
        // Using the variable fixes the warning
        print('Created a ${myCar.color} car.');
        print(
          "Go to Line 1225 - 1235 for the Example of Basic Method and Property Chaining\n",
        );
        break;
      case 2:
        print("\t2. Null-Shorting Cascade (?..)");
        print(
          "\t\tThis ensures your code doesn't crash if the object you're trying to cascade is null. Instead of throwing an error, it simply skips the cascade operations if the object is null.",
        );
        Profile? myProfile; // This is currently null

        // The ?.. operator skips all subsequent operations because myProfile is null
        myProfile
          ?..username = 'DartUser'
          ..load();

        print('No error occurred despite the null object.');
        print(
          "Go to Line 1240 - 1250 for the Example of Null-Shorting Cascade\n",
        );
        break;
      case 3:
        print("\t3. Nesting Cascades");
        print(
          "\t\tYou can nest a cascade inside another cascade to configure child objects. This is particularly useful when you have complex objects with nested properties.",
        );
        var myTruck = Truck()
          ..model = 'F-150'
          ..engine = (Engine()..horsepower = 450.0); // Nested cascade

        print('Model: ${myTruck.model}, HP: ${myTruck.engine?.horsepower}');
        print("Go to Line 1255 - 1265 for the Example of Nesting Cascades\n");
        break;
      case 4:
        print("\t4. Working with Collections");
        print(
          "\t\tCascades can also be used to manipulate collections like Lists and Sets, allowing you to add, remove, and sort items in a fluent style.",
        );
        // Note: List must be mutable
        var tasks = ['Email', 'Call']
          ..add('Meeting')
          ..remove('Email')
          ..insert(0, 'Breakfast')
          ..sort();

        print('Task list: $tasks');
        print(
          "Go to Line 1270 - 1280 for the Example of Working with Collections\n",
        );
        break;
      case 5:
        print("\t5. Complex Object Configuration (Flutter Style)");
        print(
          "This mimics how Flutter developers configure 'heavy' objects like a Paint object for custom drawing.",
        );
        // Setting multiple specific properties efficiently
        final brush = MockPaint()
          ..color = 'Green'
          ..width = 4.5
          ..isAntiAlias = false;

        print('Brush: ${brush.color}, Width: ${brush.width}');
        print(
          "Go to Line 1285 - 1295 for the Example of Complex Object Configuration\n",
        );
        break;
      case 6:
        mainmenu();
        break;
      case 7:
        exit(0);
      default:
        print('Invalid choice. Please enter a number from 1 to 7.');
        break;
    }
  } while (true);
}

void operators() {
  print(
    "Operators in Dart are special symbols that perform operations on operands. They can be categorized into several types based on their functionality. Here’s an overview of the different types of operators in Dart:",
  );
  do {
    print(
      "\n\t\t\t1. Arithmetic Operators\n\t\t\t2. Assignment Operators\n\t\t\t3. Comparison Operators\n\t\t\t4. Logical Operators\n\t\t\t5. Bitwise Operators\n\t\t\t6. Type Test Operators\n\t\t\t7. Conditional (Ternary) Operator\n\t\t\t8. Cascade Notation Operator\n\t\t\t9. Move Back\n\t\t\t10. Exit",
    );
    int option = input();
    switch (option) {
      case 1:
        arithmaticoperators();
        break;
      case 2:
        assignment();
        break;
      case 3:
        comparison();
        break;
      case 4:
        logical();
        break;
      case 5:
        bitwise();
        break;
      case 6:
        typetest();
        break;
      case 7:
        conditional();
        break;
      case 8:
        cascade();
        break;
      case 9:
        mainmenu();
        break;
      case 10:
        exit(0);
      default:
        print('Invalid choice. Please enter a number from 1 to 10.');
        break;
    }
  } while (true);
}

//#############################################################################
//@@@@@@@@@@@@@@ LOOPS EXAMPLES @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//#############################################################################

void forloop() {
  print(
    "For loop : In Dart, a for loop is used to execute a block of code repeatedly.",
  );
  for (int i = 0; i <= 10; i++) {
    print(i);
  }
  print("This is how the For Loop Works\n");
  print("The Example for the For Loop is at Line 1360 - 1370\n");
}

void whileloop() {
  int i = 0;
  print(
    "In Dart, a while loop is a control flow statement that repeatedly executes a block of code as long as a specified boolean condition evaluates to true. Because the condition is checked before each iteration, it is known as a pre-test loop; if the initial condition is false, the code block may never execute.",
  );
  while (i < 10) {
    i++;
    if (i == 5) break; // Exits the loop entirely when i reaches 5
    print(i);
  }
  print("This is how the While Loop Works\n");
  print("The Example for the While Loop is at Line 1375 - 1385\n");
}

void dowhile() {
  print(
    "The do-while loop in Dart is a 'post-test' loop that executes a block of code at least once before evaluating the condition. It is ideal for scenarios where an initial action must happen before checking whether to continue, such as user input validation or displaying a menu. ",
  );
  int x = 10;
  do {
    print('This prints once');
  } while (x < 5); // False initially, but body already executed
  print("This is how the Do-While Loop Works\n");
  print("The Example for the Do-While Loop is at Line 1385 - 1395\n");
}

void forin() {
  print(
    "This is the preferred way to iterate through a list or set because it is cleaner and avoids manual indexing. Can also be called An elegant way to iterate over Iterable collections like Lists or Sets without managing an index.",
  );
  var fruits = ['apple', 'banana', 'orange'];
  for (var fruit in fruits) {
    print(fruit);
  }
  print("This is how the For-In Loop Works\n");
  print("The Example for the For-In Loop is at Line 1400 - 1410\n");
}

void foreach() {
  print(
    "In Dart, forEach is a method available on all Iterable collections, such as List and Set, as well as on Map objects. It provides a functional way to perform an action on every element in a collection by passing a callback function. ",
  );
  Map<String, String> capitals = {
    'India': 'New Delhi',
    'USA': 'Washington D.C.',
    'Japan': 'Tokyo',
  };

  capitals.forEach((country, city) {
    print("The capital of $country is $city.");
  });
  print("This is how the For Each Loop Works\n");
  print("The Example for the For Each Loop is at Line 1410 - 1425\n");
}

void breakexample() {
  print(
    "In Dart, the break statement is used to immediately terminate the execution of the nearest enclosing loop (for, while, or do-while) or a switch statement. Once encountered, control shifts to the statement following the loop.",
  );
  for (int i = 1; i <= 10; i++) {
    if (i == 5) {
      break; // Stops the loop when i is 5
    }
    print(i);
  }
  // Execution continues here after the break
  print("Loop terminated early.");
  print("This is how the Break Statement Works\n");
  print("The Example for the Break Statement is at Line 1440 - 1440\n");
}

void continueexample() {
  print(
    "In Dart, the continue statement tells the loop to skip the rest of the current iteration and jump straight to the next one. It’s perfect for filtering out specific items without stopping the entire process.",
  );
  var fruits = ['apple', 'banana', 'cherry', 'date'];

  for (var fruit in fruits) {
    if (fruit.startsWith('b')) {
      continue; // Skip fruits starting with 'b'
    }
    print("I like $fruit");
  }
  print("This is how the Continue Statement Works\n");
  print("The Example for the Continue Statement is at Line 1445 - 1455\n");
}

void labels() {
  print(
    "In Dart, a label is an identifier followed by a colon (labelName:) that you place before a statement or a code block. While Dart does not have a goto statement, labels give you precise control over where break and continue should jump, which is especially useful for managing nested loops. ",
  );
  var status = 'initial';

  switch (status) {
    case 'initial':
      print('Setting up...');
      continue nextStep; // Jumps to the case labeled 'nextStep'

    nextStep: // Label for the next case
    case 'loading':
      print('Loading data...');
      break;

    case 'done':
      print('Finished.');
      break;
  }
  print("This is how the Labels Works\n");
  print("The Example for the Labels is at Line 1460 - 1475\n");
}

// Await For Example

// A simple generator function that creates a stream of numbers
Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    yield i; // Adds a number to the stream
  }
}

// Your requested function implementation
// The 'awaitfor' function consumes a stream but doesn't yield any values itself.
// Therefore, it should be an 'async' function returning Future<void>, not 'async*'.
Future<void> awaitfor() async {
  Stream<int> stream = countStream(5); // Get a stream of 1 to 5

  print("Starting stream loop...");

  // The 'await for' loop starts here
  await for (int value in stream) {
    print("Received: $value");
  }

  print("Stream closed. Loop finished!");
}

//await can only be called in an async function hence this calling tecnnique
void awaitforcall() async {
  await awaitfor();
  print("Returned to the main menu after processing the stream.");
  print("Go to Line 1480 - 1510 for the Example of Await For Loop\n");
}

void loops() {
  do {
    print(
      "A. Standard Loops :\n\t1. For Loop.\n\t2. While Loop\n\t3. Do-While Loop\n\nB.  Collection-Based Loops :\n\n\t\t4. For-In Loop\n\t\t5. For Each\n\n\tC. Loop Fundamentals or Advanced Codes\n\n\t\t6.Break\n\t\t7. Continue\n\t\t8. Labels\n\t\t9. Await For (Not implemented)\n\t\t10. Back\n\t\t11. Exit\n\n\t",
    );
    int option = input();

    switch (option) {
      case 1:
        forloop();
        break;
      case 2:
        whileloop();
        break;
      case 3:
        dowhile();
        break;
      case 4:
        forin();
        break;
      case 5:
        foreach();
        break;
      case 6:
        breakexample();
        break;
      case 7:
        continueexample();
        break;
      case 8:
        labels();
        break;
      case 9:
        print("Await For loop not implemented in this course");
        // Calling the function
        awaitforcall();
        break;
      case 10:
        mainmenu();
        break;
      case 11:
        exit(0);
      default:
        print("Invalid option.");
        break;
    }
  } while (true);
}
//#############################################################################
//@@@@@@@@@@@@@@ Conditional Statements @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//#############################################################################

void checkWeather(bool isRaining) {
  if (isRaining) {
    print("Take an umbrella.");
  } else {
    print("Enjoy the sunshine!");
  }
}

//Nested if statements
void checkEntry(bool hasId, int age) {
  if (hasId) {
    // This code is now reachable because 'hasId' depends on the function call
    if (age >= 21) {
      print("Entry allowed.");
    } else {
      print("Underage: Entry denied.");
    }
  } else {
    print("No ID: Entry denied.");
  }
  print("This is how the Nested If Statement Works\n");
  print("The Example for the Nested If Statement is at Line 1575 - 1590\n");
}

void conditionalstatements() {
  print(
    "Conditional statements in Dart allow you to control the flow of your program based on certain conditions. The main types of conditional statements are if, else if, else, and switch. These statements enable you to execute different blocks of code depending on the evaluation of boolean expressions.",
  );
  do {
    print(
      "\n\t\t\t1. If Statement\n\t\t\t2. If-Else Statement\n\t\t\t3. Else-If Ladder\n\t\t\t4. Nested if\n\t\t\t5. Switch Statement\n\t\t\t6. Move Back\n\t\t\t7. Exit",
    );
    int option = input();
    switch (option) {
      case 1:
        print("\t1. If Statement");
        print("Used when you only care if a single condition is met.");
        int age = 20;
        if (age >= 18) {
          print("You are eligible to vote.");
        }
        print("This is how the If Statement Works\n");
        print("The Example for the If Statement is at Line 1590 - 1605\n");
        break;
      case 2:
        print("\t2. If-Else Statement");
        print(
          "Used when you want to execute one block of code if a condition is true, and another block if it's false.",
        );
        checkWeather(false);
        print("This is how the If-Else Statement Works\n");
        print("The Example for the If-Else Statement is at Line 1610 - 1615\n");
        break;
      case 3:
        print("\t3. Else-If Ladder");
        print("Used when you have multiple conditions to check.");
        int speed = 75;
        if (speed > 80) {
          print("You are speeding fast!");
        } else if (speed > 60) {
          print("You are driving at a moderate speed.");
        }
        print("This is how the Else-If Ladder Works\n");
        print("The Example for the Else-If Ladder is at Line 1620 - 1630\n");
        break;
      case 4:
        print("\t4. Nested if");
        print(
          "An if statement placed inside another if. This is used when a second check depends entirely on the first one passing.",
        );
        // Now you can pass different values to test each path
        checkEntry(true, 21);
        checkEntry(true, 18);
        checkEntry(false, 25);
        break;
      case 5:
        print("\t5. Switch Statement");
        print(
          "Used when you have a variable that can take on multiple discrete values and you want to execute different code for each value. It’s often cleaner than multiple if-else statements for the same variable.",
        );
        String day = 'Monday';
        switch (day) {
          case 'Monday':
            print("Start of the work week.");
            break;
          case 'Friday':
            print("End of the work week.");
            break;
          default:
            print("It's $day.");
        }
        print("This is how the Switch Statement Works\n");
        print("The Example for the Switch Statement is at Line 1645 - 1665\n");
        break;
      case 6:
        mainmenu();
        break;
      case 7:
        exit(0);
      default:
        print('Invalid choice. Please enter a number from 1 to 7.');
        break;
    }
  } while (true);
}

//####################################################################
//#################  Menu Section  ##################################
//####################################################################

void mainmenu() {
  do {
    print(
      "***********Main Menu****************\n\t\t1.Variable\n\t\t2.Modern Data Types\n\t\t3.Collection\n\t\t4.Methods of Adding Data to a Collection\n\t\t5.Removing data techniques\n\t\t6.Operators\n\t\t7.Conditional Statements\n\t\t8.loops\n\t\t9.Exit",
    ); // Added Exit option
    int choice = input(); // This should ideally read from user input
    switch (choice) {
      case 1:
        variabletype();
        break;
      case 2:
        modernDatatypes();
        break;
      case 3:
        collection();
        break;
      case 4:
        addingelemets();
        break;
      case 5:
        removingDatafromset();
        print("Removing data from set function call (not present in snippet)");
        break;
      case 6:
        operators();
        break;
      case 7:
        conditionalstatements();
        break;
      case 8:
        loops();
        break;
      case 9: // Added Exit option
        exit(0);
      default:
        print('Invalid choice. Please enter a number from 1 to 9.');
        break;
    }
  } while (true); // Loop indefinitely until the user chooses to exit
}

//###############################################################################
//##############################################################################
//@@@@@@@@@@@@@@@@@@@@@@@@@ Simple Demonstrations @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//############################################################################
//##############################################################################

void simplefunctions() {
  print(
    "\n\nStep 2: Basic Dart Demonstration\n(Better Examples Already Seen So Please Continue)",
  );
  do {
    print(
      "\t\t\t1.Input Output Examples\n\t\t\t2. Simple Logic Using Conditions\n\t\t\t3. Loop-Based problems\n\t\t\t4. Exit",
    );
    int option = input();
    switch (option) {
      case 1:
        print("\t\t\t1.Input Output Examples");
        print("Enter your name:");
        String? name = stdin.readLineSync();
        print("Hello, $name!");
        print("Hello, World!"); // Output example
        print("This is how Input and Output Works\n");
        print("The Example for Input and Output is at Line 1740 - 1745\n");
        break;
      case 2:
        print("\t\t\t2. Simple Logic Using Conditions");
        int number = 10;
        if (number % 2 == 0) {
          print("$number is even.");
        } else {
          print("$number is odd.");
        }
        print("This is how Conditional Logic Works\n");
        print("The Example for Conditional Logic is at Line 1740 - 1750\n");
        break;
      case 3:
        print("\t\t\t3. Loop-Based problems(number series and sum together)");
        int sum = 0;
        for (int i = 1; i <= 5; i++) {
          print("Number: $i");
          sum = sum + i;
        }
        print("This is how Loops Work\n");
        print("The Example for Loops is at Line 1750 - 1760\n");
        break;
      case 4:
        print("\t\t\t4. Exit");
        exit(0);
      default:
        print('Invalid choice. Please enter a number from 1 to 3.');
        break;
    }
  } while (true); // Loop indefinitely until the user chooses to exit
}

void assignment2() {
  print(
    "Welcome to the Dart Basics Course! This course is designed to introduce you to the fundamental concepts of Dart programming. Whether you're new to programming or just new to Dart, this course will provide you with a solid foundation to build upon.",
  );
  print(
    "\nIn this course, we will cover the following topics:\n\n1. Variables and Data Types: Learn how to declare and use variables, and understand the different data types available in Dart.\n\n2. Operators: Explore the various operators in Dart, including arithmetic, assignment, comparison, logical, and more.\n\n3. Conditional Statements: Understand how to control the flow of your program using if, else if, else, and switch statements.\n\n4. Loops: Learn how to execute a block of code multiple times using for, while, do-while loops, and more.\n\n5. Functions: Discover how to create reusable blocks of code with functions, including parameters and return values.\n\n6. Collections: Get familiar with lists, sets, maps, and how to manipulate them effectively.\n\n7. Input and Output: Learn how to read user input and display output in the console.\n\nBy the end of this course, you will have a strong understanding of Dart's core features and be ready to start building your own applications. Let's get started!",
  );
  //Step 1: Learning Basics of Dart Programming Concepts
  do {
    print(
      "Which Assignment Part do you want to start with\n\tStep 1. Learn Basic Dart Programming Concepts, Including\n\n\t\t @ Variables and data types\n\t\t @ Operators\n\t\t @ Conditional Statements(if, else, switch)\n\t\t @ Loops (for, While, Do-While)\n\n\t2. Step 2. Write Dart Programs demonstrating these concepts\n\n\t\t @ Input and output\n\t\t @ Simple logic using conditions\n\t\t @ Loops-based Problems (e.g. Number series, sums)\n\n\t3. Exit",
    );
    int choice = input();
    switch (choice) {
      case 1:
        print("Starting Step 1. => ");
        mainmenu();
        break;
      case 2:
        print("Starting Step 2. => ");
        simplefunctions();
        break;
      case 3:
        print("Exiting the program. Goodbye!");
        exit(0);
      default:
        print('Invalid choice. Please enter a number from 1 to 3.');
        break;
    }
  } while (true); // Infinite loop to keep the program running until the user chooses to exit
}

void stringmanipulation() {
  String rawText = "  Hello, Dart Programmer!  ";

  // 1. Interpolation: Use $ for variables or ${} for expressions
  String greeting = "Welcome. Original text: '$rawText'";
  print(greeting);

  // 2. Trimming: Remove leading and trailing whitespace
  String trimmed = rawText.trim();
  print("Trimmed: '$trimmed'"); // Output: 'Hello, Dart Programmer!'

  // 3. Case Conversion: Upper and Lower case
  print("Uppercase: ${trimmed.toUpperCase()}"); // HELLO, DART PROGRAMMER!
  print("Lowercase: ${trimmed.toLowerCase()}"); // hello, dart programmer!

  // 4. Substring: Extract a portion of the string (start, end)
  // Index 7 is 'D', Index 11 is 't' (exclusive)
  String sub = trimmed.substring(7, 11);
  print("Substring (7-11): $sub"); // Output: Dart

  // 5. Replacing: Swap specific patterns
  String replaced = trimmed.replaceAll("Programmer", "Developer");
  print("Replaced: $replaced"); // Hello, Dart Developer!

  // 6. Splitting: Convert string to a List based on a delimiter
  List<String> words = trimmed.split(", ");
  print("Split List: $words"); // [Hello, Dart Programmer!]
  print("These are some Basic String Manipulation Examples");
  print(
    "the code related to same is present at line number 1800 - 1830, respectively",
  );
}

//#############################################################################
//@@@@@@@@@@@@@@@@@@@ Object-Oriented Programming (OOP) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//#############################################################################

//@@@@@@@@@@@@@@@@@@@@@1. Classes and Objects@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

class Cars {
  String brand;
  int year;

  Cars(this.brand, this.year); // Constructor

  void drive() => print("$brand is driving.");
}

void classandobjects() {
  var myCar = Cars("Toyota", 2024); // Creating an object
  myCar.drive(); // Output: Toyota is driving.
  print("This is how Classes and Objects Work\n");
  print("The Example for Classes and Objects is at Line 1840 - 1855\n");
}

//@@@@@@@@@@@@@@@@@@@@@2. Encapsulation@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

class BankAccount {
  double _balance = 0; // Private variable

  void deposit(double amount) {
    if (amount > 0) _balance += amount;
  }

  double get balance => _balance; // Getter
}

//@@@@@@@@@@@@@@@@@@@@@3. Inheritance@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

class Animal {
  void eat() => print("Eating...");
}

class Dog extends Animal {
  void bark() => print("Woof!");
}

//@@@@@@@@@@@@@@@@@@@@@4. Polymorphism@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

class Shapes {
  void draw() => print("Drawing a shape.");
}

class Circles extends Shapes {
  @override
  void draw() => print("Drawing a circle.");
}

//@@@@@@@@@@@@@@@@@@@@@5. Abstraction@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

abstract class Appliance {
  void turnOn(); // Abstract method (no body)
}

class Fan extends Appliance {
  @override
  void turnOn() => print("Fan is spinning.");
}

//@@@@@@@@@@@@@@@@@@@@@6. Mixins@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

mixin Flyable {
  void fly() => print("Flying...");
}

class Bird with Flyable {}

// Main OOP Function to demonstrate all concepts

void oop() {
  print(
    "Object-Oriented Programming (OOP) in Dart is a programming paradigm that uses 'objects' to design applications. It allows you to model real-world entities and their interactions in a way that is intuitive and organized. The core principles of OOP include encapsulation, inheritance, and polymorphism.",
  );
  do {
    print(
      "\n\t\t1. Classes and Objects\n\t\t2. Encapsulation\n\t\t3. Inheritance\n\t\t4. Polymorphism\n\t\t5. Abstraction\n\t\t6. Mixins\n\t\t7. Move Back\n\t\t8. Exit",
    );
    int option = input();
    switch (option) {
      case 1:
        print("\t1. Classes and Objects");
        print(
          "A class is a blueprint for creating objects, which are instances of that class. A class defines properties (attributes) and methods (functions) that the objects created from the class can use.",
        );
        break;
      case 2:
        print("\t2. Encapsulation");
        print(
          "Encapsulation is the bundling of data and methods that operate on that data within a single unit (class). It restricts direct access to some of an object's components, which is a way of preventing unintended interference and misuse of the data.",
        );
        print("The Example for Encapsulation is at Line 1857 - 1867\n");
        break;
      case 3:
        print("\t3. Inheritance");
        print(
          "Inheritance allows a class to acquire the properties and methods of another class. The class that inherits is called the subclass, and the class being inherited from is called the superclass.",
        );
        print("The Example for Inheritance is at Line 1869 - 1875\n");
        break;
      case 4:
        print("\t4. Polymorphism");
        print(
          "Polymorphism allows objects of different types to be treated as instances of the same type through a common interface. It enables a single interface to be used to represent different underlying data types.",
        );
        print("The Example for Polymorphism is at Line 1880- - 1886\n");
        break;
      case 5:
        print("\t5. Abstraction");
        print(
          "Abstraction is the process of hiding complex implementation details and showing only the essential features of an object. It helps in reducing complexity and improving maintainability.",
        );
        print("The Example for Abstraction is at Line 1890 - 1900\n");
        break;
      case 6:
        print("\t6. Mixins");
        print(
          "Mixins are a way to reuse code in multiple classes without using inheritance. A mixin is a class that provides methods for use by other classes without being a base class itself.",
        );
        print("The Example for Mixins is at Line 1903 - 1906\n");
        break;
      case 7:
        step1();
        break;
      case 8:
        mainmenu();
        break;
      default:
        print('Invalid choice. Please enter a number from 1 to 8.');
        break;
    }
  } while (true);
}

void step1() {
  print(
    "\nPlease explore these concepts through the main menu and practice writing code to solidify your understanding.",
  );
  do {
    print(
      "Step 1: Learn Advanced Dart Concepts\n\n1. Functions (with parameters and return types)\n2. Lists, Sets, and Maps (Dart's collection types)\n3. String Manipulation\n4. Basic object-oriented concepts",
    );
    int option = input();
    switch (option) {
      case 1:
        print(
          "A Proper Example of Function with parameter with return type is Displayed below with Function call. The Respective line numbers of the same code will be printed as code ends...",
        );
        guardclause();
        break;
      case 2:
        print(
          "Lists, Sets, and Maps are implemented in multiple Functions seperately and to get basic examples of each we have a function called collections(). see through it....",
        );
        collection();
        break;
      case 3:
        stringmanipulation();
        break;
      case 4:
        print(
          "Basic object-oriented concepts include understanding classes and objects, encapsulation, inheritance, polymorphism, abstraction, and mixins. These concepts allow you to model real-world entities and their interactions in a way that is intuitive and organized.",
        );
        print(
          "A class is a blueprint, while an object is an instance of that blueprint.\n\t\t\t Example in this Program is a Linkedlist Implementation",
        );
        oop();
        break;
      default:
        print('Invalid choice. Please enter a number from 1 to 4.');
        break;
    }
  } while (true);
}

void operaiononlistandmaps() {
  print(
    "Operations on Lists and Maps include adding, removing, and accessing elements, as well as iterating through collections. These operations are fundamental for managing data in Dart applications.",
  );
  do {
    print(
      "The 3 main Operations on Lists and Maps are :\n\n1. Adding Elements\n2. Removing Elements\n3. Accessing Elements",
    );
    int option = input();
    switch (option) {
      case 1:
        addingelemets();
        break;
      case 2:
        removingDatafromset();
        print("Removing data from set function call (not present in snippet)");
        break;
      case 3:
        print(
          "Accessing elements in a List is done using an index, while in a Map, you access values using keys.",
        );
        List<String> myList = ['apple', 'banana', 'cherry'];
        print(
          "Accessing List element at index 1: ${myList[1]}",
        ); // Output: banana

        Map<String, String> myMap = {'name': 'Alice', 'city': 'Wonderland'};
        print(
          "Accessing Map value for key 'name': ${myMap['name']}",
        ); // Output: Alice
        print("This is how Accessing Elements Works\n");
        print("The Example for Accessing Elements is at Line 2030 - 2040\n");
        break;
      default:
        print('Invalid choice. Please enter a number from 1 to 3.');
        break;
    }
  } while (true);
}

void step2() {
  do {
    print("Choose one of the three options");
    print(
      "1. User-Defined Functions\n2. Operations on Lists and Maps\n3. Simple class and Object usage",
    );
    int option = input();
    switch (option) {
      case 1:
        print(
          "User-Defined Functions are functions that you create to perform specific tasks in your Dart programs. They allow you to encapsulate code for reuse and improve the organization of your codebase.",
        );
        guardclause();
        break;
      case 2:
        print(
          "Operations on Lists and Maps include adding, removing, and accessing elements, as well as iterating through collections. These operations are fundamental for managing data in Dart applications.",
        );
        collection();
        operaiononlistandmaps();
        break;
      case 3:
        print(
          "Simple class and Object usage involves creating classes to define the structure of objects, instantiating those classes to create objects, and using methods to perform actions on those objects.",
        );
        classandobjects();
        break;
      default:
        print('Invalid choice. Please enter a number from 1 to 3.');
        break;
    }
  } while (true);
}

void assignment3() {
  do {
    print("Starting Assignment 3. => ");
    print("Choose Any One : Step 1: Learn Advanced Dart concepts, including:");
    print(
      "\n\t\t @ Functions (with parameters and return types)\n\t\t @ Lists, Sets, and Maps (Dart's collection types)\n\t\t @ String Manipulation\n\t\t @ Basic object-oriented concepts",
    );
    print(
      "\n\t Step 2: Create Dart Programs that Demonstrate:\n\n\t\t @ User-Defined Functions\n\t\t @ Operations on Lists and Maps\n\t\t @ Simple class and Object usage",
    );
    int option = input();
    switch (option) {
      case 1:
        print("Starting Step 1. => ");
        step1();
        break;
      case 2:
        print("Starting Step 2. => ");
        step2();
        break;
      default:
        print('Invalid choice. Please enter a number from 1 to 2.');
        break;
    }
  } while (true);
}

void main() {
  print(
    "Welcome to the Dart Basics Course! This course is designed to introduce you to the fundamental concepts of Dart programming. Whether you're new to programming or just new to Dart, this course will provide you with a solid foundation to build upon.",
  );
  do {
    print(
      "Choose the Assigment You Want to See : \n\n\t\t1. Assignment 2(Part 1)\n\t\t2. Assignment 3(Part 2)",
    );
    int choice = input();
    switch (choice) {
      case 1:
        print("Starting Assignment 2. => ");
        assignment2();
        break;
      case 2:
        print("Starting Assignment 3. => ");
        assignment3();
        print("Assignment 3 is not implemented yet.");
        break;
      default:
        print('Invalid choice. Please enter a number from 1 to 2.');
        break;
    }
  } while (true);
  // The program ends here if no input loop is implemented,
  // or it will exit if the 'exit' function is called.
}
