# simple-neural-network
Collection of PC and Arduino Neural Network Applications.

The code provided here is a simple multilayer perceptron (MLP) neural network implementation coded from scratch and based upon an article by Matt Mazur (https://mattmazur.com/2015/03/17/a-step-by-step-backpropagation-example/).

It is accompanied by four articles written for Elektor:
* Part 1: Artificial Neurons https://www.elektormagazine.com/articles/neural-networks-part-1-artificial-neurons
* Part 2: Logical Neurons https://www.elektormagazine.com/articles/neural-networks-part-2-logical-neurons
* Part 3: Practical Neurons https://www.elektormagazine.com/articles/neural-networks-part-3-practical-neurons/
* Part 4: Embedded Neurons https://www.elektormagazine.com/news/neural-networks-part-4-embedded-neurons

The folders contain the following:

* workedexample - This contains a spreadsheet that performs all the calculations undertaken in the Matt Mazur article. It can be used to explore the math of backpropagation.
* processing - This contains a series of example projects for Processing (https://processing.org/) that use the MLP created. They test the MLP implementation as well as show how it learns various logic functions (AND, OR, XOR) while visualizing the weights during learning.
* trafficlight - These projects show how a webcam and Processing can be used to 'learn' the colors of a traffic light. An example traffic light image is included.
* arduino - This contains projects for an Arduino board together with the Adafruit TCS34725 (https://www.adafruit.com/product/1334) to perform traffic light color classification on a microcontroller. A 32-bit board is recommended (Arduino DUE, Arduino M0 Pro); 8-bit boards will struggle with the backpropagation.

Hope you enjoy the code! Let me know your experiences with it.
