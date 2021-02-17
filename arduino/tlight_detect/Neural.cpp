/*
  neural.h - Library for Neural Network.
  Created by Stuart Cording, Sept 9th, 2017.
  Released into the public domain.
*/

#include "Arduino.h"
#include "Neural.h"

static double sigmoid(double x) {
  return (1 / (1 + exp(-x)));
}

static double derivativeSigmoid(double x) {
  return (sigmoid(x) * (1 - sigmoid(x)));
}

Neural::Neural(int inputs, int hidden, int outputs)
{
    // Set all variables to zero to start that don't have to be defined here
    biasInputToHidden = 0.0;
    biasHiddenToOutput = 0.0;
    learningRate = 0.0;
    totalNetworkError = 0.0;

    // Note that we are not in learning mode
    learning = false;
    
    // Note that we are not in verbose mode
    verbose = false;
    
    // Set learning epoch to 0
    learningEpoch = 0;
    
    // Note the original number of nodes created
    noOfInputs = inputs;
    noOfHidden = hidden;
    noOfOutputs = outputs;
    
    // Create the desired number of input nodes and set them to zero
    inputNodeValues = new double [inputs];
    for (int x = 0; x < inputs; ++x) {
        inputNodeValues[x] = 0.0;
    }

    // Create the desired number of hidden nodes and set them to zero
    hiddenNodeValues = new double [hidden];
    for (int x = 0; x < hidden; ++x) {
        hiddenNodeValues[x] = 0.0;
    }

    // Create the desired number of output and desired output nodes and set them to zero
    outputNodeValues = new double [outputs];
    desiredOutputNodeValues = new double [outputs];
    for (int x = 0; x < inputs; ++x) {
        outputNodeValues[x] = 0.0;
        desiredOutputNodeValues[x] = 0.0;
    }

    // For each input node, create both old and new weights
    // for each hidden node
    inputToHiddenWeights = new double*[inputs];
    for (int x = 0; x < inputs; ++x) {
        inputToHiddenWeights[x] = new double[hidden];
    }
    
    newInputToHiddenWeights = new double*[inputs];
    for (int x = 0; x < inputs; ++x) {
        newInputToHiddenWeights[x] = new double[hidden];
    }
    
    for (int x = 0; x < inputs; ++x) {
        for (int y = 0; y < hidden; ++y) {
            static double fnum;
            fnum = (random(250, 750)) / 1000.0;
            // Apply starting random weights to current nodes
            inputToHiddenWeights[x][y] = fnum;
            // New weights can have 0.0 for now
            newInputToHiddenWeights[x][y] = 0.0;
        }
    }
    
    // For each hidden node, create both old and new weights
    // for each output node
    hiddenToOutputWeights = new double*[hidden];
    for (int x = 0; x < hidden; ++x) {
        hiddenToOutputWeights[x] = new double[outputs];
    }
    
    newHiddenToOutputWeights = new double*[hidden];
    for (int x = 0; x < hidden; ++x) {
        newHiddenToOutputWeights[x] = new double[outputs];
    }
    
    for (int x = 0; x < hidden; ++x) {
        for (int y = 0; y < outputs; ++y) {
            static double fnum;
            fnum = (random(250, 750)) / 1000.0;
            // Apply starting random weights to current nodes
            hiddenToOutputWeights[x][y] = fnum;
            // New weights can have 0.0 for now
            newHiddenToOutputWeights[x][y] = 0.0;
        }
    }
}

void Neural::calculateOutput() {
    double tempResult = 0.0;
    
    // Start by calculating the hidden layer node results for each input node
    // For each hidden node Hn:
    //   Hn = sigmoid (wn * in + w(n+1) * i(n+1) ... + Hbias * 1)
    for (int x = 0; x < getNoOfHiddenNodes(); ++x) {
        for (int y = 0; y < getNoOfInputNodes(); ++y) {
            // Sum the results for the weight * input for each input node
            tempResult += inputNodeValues[y] * inputToHiddenWeights[y][x];
            if (verbose) {
                Serial.print("i[");
                Serial.print(y);
                Serial.print("] ");
                Serial.print(inputNodeValues[y]);
                Serial.print(" * iToHW[");
                Serial.print(y);
                Serial.print(x);
                Serial.print("] ");
                Serial.print(inputToHiddenWeights[y][x]);
                Serial.print(" += ");
                Serial.println(tempResult);
            }
        }
      
        // Add bias value result to sum
        tempResult += 1.0 * biasInputToHidden;
        if (verbose) {
            Serial.print("Bias: 1.0 * ");
            Serial.print(biasInputToHidden);
            Serial.print(" += ");
            Serial.println(tempResult);
        }
      
        // Squash result using sigmoid of sum 
        hiddenNodeValues[x] = sigmoid(tempResult);
        if (verbose) {
            Serial.print("Sigmoid:");
            Serial.println(hiddenNodeValues[x]);
        }
      
        // Reset sumation variable for next round
        tempResult = 0.0;
    }
    
    // Next calculating the output layer node results for each hidden node
    // For each output node On:
    //   On = sigmoid (wn * Hn + w(n+1) * Hn(n+1) ... + Obias * 1)
    for (int x = 0; x < getNoOfOutputNodes(); ++x) {
        for (int y = 0; y < getNoOfHiddenNodes(); ++y) {
        
            tempResult += hiddenNodeValues[y] * hiddenToOutputWeights[y][x];
            if (verbose) {
                Serial.print("h[");
                Serial.print(y);
                Serial.print("] ");
                Serial.print(hiddenNodeValues[y]);
                Serial.print(" * hToOW[");
                Serial.print(y);
                Serial.print(" ");
                Serial.print(x);
                Serial.print("] ");
                Serial.print(hiddenToOutputWeights[y][x]);
                Serial.print(" += ");
                Serial.println(tempResult);
            }
        }
      
        // Add bias value
        tempResult += 1.0 * biasHiddenToOutput;
        if (verbose) {
            Serial.print("Bias: 1.0 * ");
            Serial.print(biasHiddenToOutput);
            Serial.print(" += ");
            Serial.println(tempResult);
        }
      
        // Result goes into the output node
        outputNodeValues[x] = sigmoid(tempResult);
        if (verbose) {
            Serial.print("Sigmoid:");
            Serial.println(outputNodeValues[x]);
        }
      
          // Reset sumation variable for next round
          tempResult = 0.0;
    }
    
    // Calculate total error
    // ERRORtotal = SUM 0.5 * (target - output)^2
    for (int x = 0; x < getNoOfOutputNodes(); ++x) {
        //tempResult += 0.5 * ((desiredOutputNodeValues[x] - outputNodeValues[x]) * 
        //                      (desiredOutputNodeValues[x] - outputNodeValues[x]));
        tempResult += 0.5 * sq(desiredOutputNodeValues[x] - outputNodeValues[x]);
        if (verbose) {
            Serial.print("Error o[");
            Serial.print(x);
            Serial.print("]:");
            Serial.println(tempResult);
            Serial.print(" : 0.5 * (");
            Serial.print(desiredOutputNodeValues[x]);
            Serial.print("-");
            Serial.print(outputNodeValues[x]);
            Serial.println(")^2");
        
        }
    }
    
    if (verbose) {
        Serial.print("Total Error: ");
        Serial.println(tempResult);
    }
    
    totalNetworkError = tempResult;
    
    if (learning) {
        if (verbose) {
            Serial.println(">>> Executing learning loop...");
        }
        _backPropagation();
        if (verbose) {
            Serial.print(">>> Learning loop complete. Epoch = ");
            Serial.println(learningEpoch);
        }
    }
}

/* _backPropagation()
   * Uses network error to update weights when learning is 
   * enabled.
   */
void Neural::_backPropagation() {
    double totalErrorChangeWRTOutput = 0.0;
    double outputChangeWRTNetInput = 0.0;
    double netInputChangeWRTWeight = 0.0;
    double errorTotalWRTHiddenNode = 0.0;    // NOTE: Does not seem to be used
    //int x = 0;
    
    // Increment epoch
    ++learningEpoch;
    
    // Consider the output layer to calculate new weights for hidden-to-output layer
    //   newWeightN = wn - learningRate * (ErrorTotal / impactOfwn)
    if (verbose) {
        //Serial.println("Hidden to Output Weight Correction:");
    }
    
    for (int x = 0; x < getNoOfOutputNodes(); ++x) {
      
        totalErrorChangeWRTOutput = -(desiredOutputNodeValues[x] -  outputNodeValues[x]);
        
        if (verbose) {
            //Serial.println("totalErrChangeWRTOutput [", x,"] =", totalErrorChangeWRTOutput);
        }
      
        outputChangeWRTNetInput = outputNodeValues[x] * (1 - outputNodeValues[x]);
      
        if (verbose) {
            //Serial.println("outputChangeWRTNetInput [", x,"] =", outputChangeWRTNetInput);
        }
      
        for (int y = 0; y < getNoOfHiddenNodes(); ++y) {
            double weightChange = 0.0;
        
            netInputChangeWRTWeight = hiddenNodeValues[y];
        
            weightChange = totalErrorChangeWRTOutput * outputChangeWRTNetInput * netInputChangeWRTWeight;
        
            if (verbose) {
                //Serial.println("weightChange =", weightChange, " :", totalErrorChangeWRTOutput, "*", outputChangeWRTNetInput, "*", netInputChangeWRTWeight);
            }
        
            newHiddenToOutputWeights[y][x] = hiddenToOutputWeights[y][x] - (learningRate * weightChange);
                
            if (verbose) {
                //Serial.println("Calculating", hiddenToOutputWeights[y][x], "-", learningRate, "*", weightChange);
                //Serial.println("New Weight [", y, x, "] =", newHiddenToOutputWeights[y][x], ", Old Weight =", hiddenToOutputWeights[y][x]);
            }
        }
    }
    
    // Consider the hidden layer (based upon original weights)
    if (verbose) {
      //Serial.println("Input to Hidden Weight Correction:");
    }
    
    // Need to consider for each hidden node
    for (int x = 0; x < getNoOfHiddenNodes(); ++x) {
        // For each hidden node we need:
        //   - totalErrorChangeWRTOutput
        //   - outputChangeWRTNetInput
        //   - hiddenToOutputWeights
        double totalErrorChangeWRTHidden = 0.0;
        double outputHiddenWRTnetHidden = 0.0;
        double totalErrorChangeWRTweight = 0.0;
        
        for (int y = 0; y < getNoOfOutputNodes(); ++ y) {
            // totalErrorChangeWRTOutput
            totalErrorChangeWRTOutput = -(desiredOutputNodeValues[y] -  outputNodeValues[y]);
            if (verbose) {
                //Serial.println("totalErrChangeWRTOutput [", y,"] =", totalErrorChangeWRTOutput);
            }
            
            // outputChangeWRTNetInput
            outputChangeWRTNetInput = outputNodeValues[y] * (1 - outputNodeValues[y]);
            if (verbose) {
                //Serial.println("outputChangeWRTNetInput [", y,"] =", outputChangeWRTNetInput);
            }
            
            totalErrorChangeWRTHidden += totalErrorChangeWRTOutput * outputChangeWRTNetInput * hiddenToOutputWeights[x][y];
            
            if (verbose) {
                //Serial.println("totalErrorChangeWRTHidden[", x, "] =", totalErrorChangeWRTHidden);
            }
        }
        
        outputHiddenWRTnetHidden = (hiddenNodeValues[x]) * (1 - hiddenNodeValues[x]);
        
        if (verbose) {
            //Serial.println("hiddenNodeValues[", x, "] =", hiddenNodeValues[x]);
        }
        
        if (verbose) {
            //Serial.println("outputHiddenWRTnetHidden[", x, "] =", outputHiddenWRTnetHidden);
        }
        
        // For each input, calculate the weight change
        for (int y = 0; y < getNoOfInputNodes(); ++y) {
            totalErrorChangeWRTweight = totalErrorChangeWRTHidden * outputHiddenWRTnetHidden * inputNodeValues[y];
            
            if (verbose) {
                //Serial.println("inputNodeValues[", y, "] =", inputNodeValues[y]);
            }
            
            if (verbose) {
                //Serial.println("totalErrorChangeWRTweight[", x, "] =", totalErrorChangeWRTweight);
            }
            
            newInputToHiddenWeights[y][x] = inputToHiddenWeights[y][x] - (learningRate * totalErrorChangeWRTweight);
            
            if (verbose) {
                //Serial.println("inputToHiddenWeights[", y, "][", x, "] =", inputToHiddenWeights[y][x]);
                //Serial.println("newInputToHiddenWeights[", y, "][", x, "] =", newInputToHiddenWeights[y][x]);
            }
        }
    }
    
    
    // Update all weights to newly calculated values
    if (verbose) {
        //Serial.println("Updating weights.");
    }
    
    // Update the input-to-hidden weights
    for (int x = 0; x < getNoOfInputNodes(); ++x) {
        for (int y = 0; y < getNoOfHiddenNodes(); ++y) {
            inputToHiddenWeights[x][y] = newInputToHiddenWeights[x][y];
        }
    }
    
    // Update the hidden-to-output weights
    for (int x = 0; x < getNoOfHiddenNodes(); ++x) {
        for (int y = 0; y < getNoOfOutputNodes(); ++y) {
            hiddenToOutputWeights[x][y] = newHiddenToOutputWeights[x][y];
        }
    }
}
  
void Neural::setLearningRate(double bias) {
    learningRate = bias;
}
          
double Neural::getLearningRate() {
    return learningRate;
}

void Neural::setBiasInputToHidden(double bias) {
    biasInputToHidden = bias;
}

double Neural::getBiasInputToHidden() {
    return biasInputToHidden;
}

void Neural::setBiasHiddenToOutput(double bias) {
    biasHiddenToOutput = bias;
}

double Neural::getBiasHiddenToOutput() {
    return biasHiddenToOutput;
}

void Neural::turnLearningOn() {
    learning = true;
    // Also reset learning epoch
    learningEpoch = 0;
}

void Neural::turnLearningOff() {
    learning = false;
}

void Neural::setInputNode(int node, double value) {
    inputNodeValues[node] = value;
}

double Neural::getInputNode(int node) {
    return inputNodeValues[node];
}

void Neural::setOutputNodeDesired(int node, double value) {
    desiredOutputNodeValues[node] = value;
}

double Neural::getOutputNodeDesired(int node) {
    return desiredOutputNodeValues[node];
}

int Neural::getNoOfInputNodes() {
    return noOfInputs;
}

int Neural::getNoOfHiddenNodes() {
    return noOfHidden;
}

int Neural::getNoOfOutputNodes() {
    return noOfOutputs;
}

double Neural::getOutputNode(int node) {
    return outputNodeValues[node];
}

void Neural::displayInputToHiddenWeightsCurrent() {
    for (int x = 0; x < getNoOfInputNodes(); ++x) {
        Serial.print("For Input Node ");
        Serial.print(x);
        Serial.print(": ");
        
        for (int y = 0; y < getNoOfHiddenNodes(); ++y) {
            Serial.print(inputToHiddenWeights[x][y]);
            Serial.print(" ");
        }
        
        Serial.println();
    }
}

void Neural::displayHiddenToOutputWeightsCurrent() {
        for (int x = 0; x < getNoOfHiddenNodes(); ++x) {
        Serial.print("For Hidden Node ");
        Serial.print(x);
        Serial.print(": ");
        
        for (int y = 0; y < getNoOfOutputNodes(); ++y) {
            Serial.print(hiddenToOutputWeights[x][y]);
            Serial.print(" ");
        }
        
        Serial.println();
    }
}

void Neural::turnVerboseOn() {
    verbose = true;
}

void Neural::turnVerboseOff() {
    verbose = false;
}

double Neural::getTotalNetworkError() {
    return totalNetworkError;
}

int Neural::getEpoch() {
    return learningEpoch;
}

void Neural::setInputToHiddenWeight(int input, int hidden, double value) {
    inputToHiddenWeights[input][hidden] = value;
}

double Neural::getInputToHiddenWeight(int input, int hidden) {
    return inputToHiddenWeights[input][hidden];
}

void Neural::setHiddenToOutputWeight(int hidden, int output, double value) {
    hiddenToOutputWeights[hidden][output] = value;
}

double Neural::getHiddenToOutputWeight(int hidden, int output) {
    return hiddenToOutputWeights[hidden][output];
}

boolean Neural::getLearningStatus() {
    return learning;
}

void Neural::displayInputNodes() {
    for (int x = 0; x < noOfInputs; ++x) {
        Serial.print(getInputNode(x));
        Serial.print(" ");
    }
    Serial.println();
}

void Neural::displayHiddenNodes() {
    for (int x = 0; x < getNoOfHiddenNodes(); ++x) {
        Serial.print(hiddenNodeValues[x]);
        Serial.print(" ");
    }
    Serial.println();
}

void Neural::displayOutputNodes() {
    for (int x = 0; x < getNoOfOutputNodes(); ++x) {
        Serial.print(outputNodeValues[x]);
        Serial.print(" ");
    }
    Serial.println();
}