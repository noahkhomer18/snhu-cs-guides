# CS-210 Programming Language Setup Guide

## 🎯 Purpose
Complete setup guide for Python, Java, and C++ development environments used in CS-210.

## 🐍 Python Setup

### Installation
```bash
# Windows (using Chocolatey)
choco install python

# Or download from python.org
# https://www.python.org/downloads/

# Verify installation
python --version
pip --version
```

### IDE Setup
**PyCharm Community Edition (Recommended)**
- Download: https://www.jetbrains.com/pycharm/download/
- Free, full-featured Python IDE
- Built-in debugger, code completion, Git integration

**VS Code (Alternative)**
- Download: https://code.visualstudio.com/
- Install Python extension
- Install Pylance for better IntelliSense

### Essential Packages
```bash
# Install common packages for CS-210
pip install numpy pandas matplotlib requests

# For data analysis and visualization
pip install jupyter notebook

# For testing (if needed)
pip install pytest
```

### Python Environment Setup
```bash
# Create virtual environment
python -m venv cs210_env

# Activate (Windows)
cs210_env\Scripts\activate

# Activate (Mac/Linux)
source cs210_env/bin/activate

# Install packages in virtual environment
pip install -r requirements.txt
```

## ☕ Java Setup

### Installation
**Option 1: Oracle JDK**
- Download: https://www.oracle.com/java/technologies/downloads/
- Choose JDK 11 or 17 (LTS versions)

**Option 2: OpenJDK (Free)**
```bash
# Windows (using Chocolatey)
choco install openjdk

# Or download from: https://adoptium.net/
```

### IDE Setup
**IntelliJ IDEA Community Edition (Recommended)**
- Download: https://www.jetbrains.com/idea/download/
- Free, excellent Java IDE
- Built-in Maven/Gradle support

**Eclipse (Alternative)**
- Download: https://www.eclipse.org/downloads/
- Choose "Eclipse IDE for Java Developers"

**VS Code (Lightweight)**
- Install Extension Pack for Java
- Install Spring Boot Extension Pack

### Java Environment Setup
```bash
# Verify installation
java -version
javac -version

# Set JAVA_HOME (Windows)
setx JAVA_HOME "C:\Program Files\Java\jdk-17"

# Set JAVA_HOME (Mac/Linux)
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
```

### Build Tools
**Maven Setup**
```bash
# Download from: https://maven.apache.org/download.cgi
# Add to PATH: bin directory

# Verify
mvn --version

# Create new project
mvn archetype:generate -DgroupId=com.example -DartifactId=cs210-project
```

**Gradle Setup**
```bash
# Download from: https://gradle.org/install/
# Add to PATH: bin directory

# Verify
gradle --version
```

## ⚡ C++ Setup

### Installation
**Windows:**
- Install Visual Studio Community (Free)
- Download: https://visualstudio.microsoft.com/vs/community/
- Select "Desktop development with C++" workload

**Alternative: MinGW-w64**
```bash
# Using Chocolatey
choco install mingw

# Or download from: https://www.mingw-w64.org/
```

### IDE Setup
**Visual Studio (Recommended for Windows)**
- Full-featured C++ IDE
- Built-in debugger and IntelliSense
- CMake support

**Code::Blocks (Cross-platform)**
- Download: https://www.codeblocks.org/
- Lightweight C++ IDE
- Good for learning

**VS Code (Alternative)**
- Install C/C++ Extension Pack
- Install Code Runner extension

### C++ Compiler Setup
```bash
# Verify installation (Windows with MinGW)
g++ --version

# Compile and run
g++ -o program program.cpp
./program

# With debugging
g++ -g -o program program.cpp
gdb ./program
```

## 🔧 Essential Development Tools

### Git & GitHub
```bash
# Install Git
# Windows: https://git-scm.com/download/win
# Mac: brew install git
# Linux: sudo apt install git

# Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Verify
git --version
```

### GitHub Desktop (Optional)
- Download: https://desktop.github.com/
- GUI for Git operations
- Good for beginners

### Package Managers
**Windows: Chocolatey**
```powershell
# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install common tools
choco install git nodejs python openjdk
```

**Mac: Homebrew**
```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install common tools
brew install git python openjdk node
```

## 📚 Learning Resources

### Python
- **Official Tutorial**: https://docs.python.org/3/tutorial/
- **Python.org**: https://www.python.org/about/gettingstarted/
- **Real Python**: https://realpython.com/
- **Python for Everybody**: https://www.py4e.com/

### Java
- **Oracle Java Tutorials**: https://docs.oracle.com/javase/tutorial/
- **Java Code Geeks**: https://www.javacodegeeks.com/
- **Baeldung**: https://www.baeldung.com/
- **JavaTpoint**: https://www.javatpoint.com/java-tutorial

### C++
- **C++ Reference**: https://en.cppreference.com/
- **Learn C++**: https://www.learncpp.com/
- **C++ Tutorial**: https://www.cplusplus.com/doc/tutorial/
- **GeeksforGeeks C++**: https://www.geeksforgeeks.org/c-plus-plus/

## 🛠️ Project Structure Examples

### Python Project
```
cs210_python_project/
├── src/
│   ├── __init__.py
│   ├── main.py
│   └── utils.py
├── tests/
│   └── test_main.py
├── requirements.txt
├── README.md
└── .gitignore
```

### Java Project
```
cs210_java_project/
├── src/
│   └── main/
│       └── java/
│           └── com/
│               └── example/
│                   └── Main.java
├── pom.xml
├── README.md
└── .gitignore
```

### C++ Project
```
cs210_cpp_project/
├── src/
│   ├── main.cpp
│   └── utils.cpp
├── include/
│   └── utils.h
├── CMakeLists.txt
├── README.md
└── .gitignore
```

## 🚀 Quick Start Commands

### Python
```bash
# Create new project
mkdir cs210_python_project
cd cs210_python_project
python -m venv venv
venv\Scripts\activate  # Windows
pip install numpy pandas matplotlib
```

### Java
```bash
# Create new Maven project
mvn archetype:generate -DgroupId=com.example -DartifactId=cs210-java
cd cs210-java
mvn compile
mvn exec:java -Dexec.mainClass="com.example.App"
```

### C++
```bash
# Create new project
mkdir cs210_cpp_project
cd cs210_cpp_project
# Create main.cpp
g++ -o main main.cpp
./main
```

## 💡 Pro Tips

1. **Use Virtual Environments**: Always use virtual environments for Python projects
2. **Version Control**: Initialize Git repositories for all projects
3. **IDE Features**: Learn keyboard shortcuts and debugging features
4. **Code Formatting**: Use auto-formatters (Black for Python, Prettier for others)
5. **Documentation**: Write clear comments and README files
6. **Testing**: Write tests as you develop, not after
7. **Backup**: Use GitHub for code backup and collaboration

## 🔗 Additional Resources

- **Stack Overflow**: https://stackoverflow.com/
- **GitHub Learning Lab**: https://lab.github.com/
- **FreeCodeCamp**: https://www.freecodecamp.org/
- **Codecademy**: https://www.codecademy.com/
- **Coursera**: https://www.coursera.org/
- **edX**: https://www.edx.org/
