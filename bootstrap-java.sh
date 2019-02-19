#!/bin/bash

#####################################
# Author: Leonardo Fernandes
# Date: 2019-02-15
#####################################

echo "Username:"
whoami
echo "Uptime:"
uptime
echo "Path:"
$PWD



echo "Upgrading..."
apt update
apt -y dist-upgrade
apt -y autoremove
apt clean

echo " Installing [JAVA, GCC, PERL]..."
apt install gcc make perl 
apt install openjdk-8-jdk
apt install emacs

#Building up JAVA infrastructure
if [ -d "$PWD/workspace/mutation/java" ]; then
    echo "Java directory alredy exists"
    exit 1
fi

echo "Creating workspace directories"
mkdir -p $PWD/workspace/mutation/java
mkdir -p $PWD/workspace/mutation/java/libs
mkdir -p $PWD/workspace/mutation/java/subjects
mkdir -p $PWD/workspace/mutation/java/subjects/mystack
mkdir -p $PWD/workspace/mutation/java/subjects/mystack/src/stack
mkdir -p $PWD/workspace/mutation/java/subjects/mystack/test/stack
mkdir -p $PWD/workspace/mutation/java/mujava
mkdir -p $PWD/workspace/mutation/java/major
mkdir -p $PWD/workspace/mutation/java/major/example
mkdir -p $PWD/workspace/mutation/java/major/mutants
mkdir -p $PWD/workspace/mutation/java/pit
mkdir -p $PWD/workspace/mutation/java/pit/example


#Falta Colocar os exemplos de codigo no Github
#Baixar direto para a pasta subjects
cp ~/Desktop/MyStack.java $PWD/workspace/mutation/java/subjects/mystack/src/stack
cp ~/Desktop/MyStackTest.java $PWD/workspace/mutation/java/subjects/mystack/test/stack


#Downloading JUnit-4.13, Hamcrest-1.3 and comomons-io-2.4
wget http://www.java2s.com/Code/JarDownload/junit/junit-4.10.jar.zip -P $PWD/workspace/mutation/java/libs/
wget http://www.java2s.com/Code/JarDownload/hamcrest/hamcrest-all-1.3.jar.zip -P $PWD/workspace/mutation/java/libs/
wget http://www.java2s.com/Code/JarDownload/commons-io/commons-io-2.4.jar.zip -P $PWD/workspace/mutation/java/libs/
unzip -q $PWD/workspace/mutation/java/libs/junit-4.10.jar.zip -d $PWD/workspace/mutation/java/libs/
unzip -q $PWD/workspace/mutation/java/libs/hamcrest-all-1.3.jar.zip -d $PWD/workspace/mutation/java/libs/
unzip -q $PWD/workspace/mutation/java/libs/commons-io-2.4.jar.zip -d $PWD/workspace/mutation/java/libs/


#Setup CLASSPATH
CLASSPATH=$CLASSPATH:$PWD/workspace/mutation/java/mujava/*:/usr/lib/jvm/java-8-openjdk-amd64/lib/tools.jar:$PWD/workspace/mutation/java/mujava/example/classes/:$PWD/workspace/mutation/java/mujava/example/testset/:$PWD/workspace/mutation/java/libs/* ; export CLASSPATH 

#---------------------MUJAVA----------------------------
echo " Downloading MuJava 4 from: https://cs.gmu.edu/~offutt/mujava/"
wget https://cs.gmu.edu/~offutt/mujava/mujava.jar -P $PWD/workspace/mutation/java/mujava/
wget https://cs.gmu.edu/~offutt/mujava/openjava.jar -P $PWD/workspace/mutation/java/mujava/

#GUI
echo "MuJava_HOME=$PWD/workspace/mutation/java/mujava/example" > $PWD/workspace/mutation/java/mujava/mujava.config
echo "Debug_mode=false" >> $PWD/workspace/mutation/java/mujava/mujava.config

#CLI
echo "MuJava_HOME=$PWD/workspace/mutation/java/mujava" > $PWD/workspace/mutation/java/mujava/mujavaCLI.config
echo "Debug_mode=false" >> $PWD/workspace/mutation/java/mujava/mujavaCLI.config


#Execute MuJava
cd $PWD/workspace/mutation/java/mujava/ 

#MuJava Command to create the directories
#CLI
rm -rf example/
java mujava.cli.testnew example 

cd ~/.

#Copy example files and compile
echo "Copiando source e testes"
cp -r $PWD/workspace/mutation/java/subjects/mystack/src/* $PWD/workspace/mutation/java/mujava/example/src/
cp -r $PWD/workspace/mutation/java/subjects/mystack/test/* $PWD/workspace/mutation/java/mujava/example/testset/


echo "Compilando source e testes"
javac -d $PWD/workspace/mutation/java/mujava/example/classes/ $PWD/workspace/mutation/java/mujava/example/src/stack/MyStack.java
javac -d $PWD/workspace/mutation/java/mujava/example/testset/ $PWD/workspace/mutation/java/mujava/example/testset/stack/MyStackTest.java

#MuJava command to generate mutants
cd $PWD/workspace/mutation/java/mujava/

#GUI
#java mujava.gui.GenMutantsMain

#CLI
echo "Generating the mutants"
java mujava.cli.genmutes -ALL example

#MuJava command to execute the tests

#GUI
#java mujava.gui.RunTestMain

#CLI
echo "Run the mutants" 
java mujava.cli.runmutes stack.MyStackTest example


cd ~/.

#---------------END MUJAVA-----------------------------------



#-------------------PIT-----------------
wget https://github.com/hcoles/pitest/releases/download/pitest-parent-1.4.5/pitest-1.4.5.jar -P $PWD/workspace/mutation/java/pit/

wget https://github.com/hcoles/pitest/releases/download/pitest-parent-1.4.5/pitest-ant-1.4.5.jar -P $PWD/workspace/mutation/java/pit/
wget https://github.com/hcoles/pitest/releases/download/pitest-parent-1.4.5/pitest-command-line-1.4.5.jar -P $PWD/workspace/mutation/java/pit/
wget https://github.com/hcoles/pitest/releases/download/pitest-parent-1.4.5/pitest-entry-1.4.5.jar -P $PWD/workspace/mutation/java/pit/

#Copy example files and compile
cp -r $PWD/workspace/mutation/java/subjects/mystack/src/* $PWD/workspace/mutation/java/pit/example/
cp -r $PWD/workspace/mutation/java/subjects/mystack/test/* $PWD/workspace/mutation/java/pit/example/
javac -d $PWD/workspace/mutation/java/pit/example/ $PWD/workspace/mutation/java/pit/example/stack/MyStack*.java

#Update classpath
CLASSPATH=$CLASSPATH:$PWD/workspace/mutation/java/pit/* ; export CLASSPATH

java -cp $PWD/workspace/mutation/java/pit/*:$PWD/workspace/mutation/java/libs/*:$PWD/workspace/mutation/java/pit/example/ org.pitest.mutationtest.commandline.MutationCoverageReport --reportDir $PWD/workspace/mutation/java/pit/example/ --targetClasses br.edu.ifal.mutationexperiment.MyStack --targetTests br.edu.ifal.mutationexperiment.MyStackTest --sourceDirs $PWD/workspace/mutation/java/pit/example/

#---------------------------------------


#---------------------MAJOR--------------
wget http://mutation-testing.org/downloads/major-1.3.4_jre7.zip -P $PWD/workspace/mutation/java/major/
unzip -q $PWD/workspace/mutation/java/major/major-1.3.4_jre7.zip -d $PWD/workspace/mutation/java/major/

#Copy example files and compile
cp -r $PWD/workspace/mutation/java/subjects/mystack/src/* $PWD/workspace/mutation/java/major/example/
cp -r $PWD/workspace/mutation/java/subjects/mystack/test/* $PWD/workspace/mutation/java/major/example/
javac -d $PWD/workspace/mutation/java/major/example/ $PWD/workspace/mutation/java/major/example/stack/MyStack*.java

$PWD/workspace/mutation/java/major/major/bin/javac -J-Dmajor.export.mutants=true -J-Dmajor.export.directory=$PWD/workspace/mutation/java/major/mutants -XMutator:ALL -d $PWD/workspace/mutation/java/major/example $PWD/workspace/mutation/java/major/example/stack/MyStack.java
#I dont know how to save mutants.log in the folder of major. Then move mutants.log to the major folder after execution
mv $PWD/mutants.log $PWD/workspace/mutation/java/major/

#---------------------------------------


#Open permission to all
cd ~/
chmod -R 777 $PWD/workspace/


