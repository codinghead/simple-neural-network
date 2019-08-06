class Neural {
    private float[] inputNodeValues;
    private float[] hiddenNodeValues;
    private float[] outputNodeValues;
    private float[] desiredOutputNodeValues;
    private int noOfInputs;
    private int noOfHidden;
    private int noOfOutputs;

    private float[][] inputToHiddenWeights;
    private float[][] newInputToHiddenWeights;
    private float[][] hiddenToOutputWeights;
    private float[][] newHiddenToOutputWeights;
    
    private float biasInputToHidden;
    private float biasHiddenToOutput;
    private float learningRate;
    private float totalNetworkError;
    private int learningEpoch;

    private boolean learning;
    
    private boolean verbose;
    
  // Network is created by defining number of inputs, hidden nodes and outputs
  Neural(int inputs, int hidden, int outputs) {
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
    inputNodeValues = new float [inputs];
    for (int x = 0; x < inputs; ++x) {
      inputNodeValues[x] = 0.0;
    }

    // Create the desired number of hidden nodes and set them to zero
    hiddenNodeValues = new float [hidden];
    for (int x = 0; x < hidden; ++x) {
      hiddenNodeValues[x] = 0.0;
    }

    // Create the desired number of output and desired output nodes and set them to zero
    outputNodeValues = new float [outputs];
    desiredOutputNodeValues = new float [outputs];
    for (int x = 0; x < outputs; ++x) {
      outputNodeValues[x] = 0.0;
      desiredOutputNodeValues[x] = 0.0;
    }

    // For each input node, create both old and new weights
    // for each hidden node
    inputToHiddenWeights = new float [inputs][hidden];
    newInputToHiddenWeights = new float [inputs][hidden];
    
    for (int x = 0; x < inputs; ++x) {
      for (int y = 0; y < hidden; ++y) {
        // Apply starting random weights to current nodes
        inputToHiddenWeights[x][y] = random(0.25, 0.75);
        // New weights can have 0.0 for now
        newInputToHiddenWeights[x][y] = 0.0;
      }
    }
    
    // For each hidden node, create both old and new weights
    // for each output node
    hiddenToOutputWeights = new float [hidden][outputs];
    newHiddenToOutputWeights = new float [hidden][outputs];
    
    for (int x = 0; x < hidden; ++x) {
      for (int y = 0; y < outputs; ++y) {
        // Apply starting random weights to current nodes
        hiddenToOutputWeights[x][y] = random(0.25, 0.75);
        // New weights can have 0.0 for now
        newHiddenToOutputWeights[x][y] = 0.0;
      }
    }
  }
  
  /* calculateOuput()
   * Uses the weights of the network to calculate new output.
   * Requires that user has defined their desired input values
   * and trained the network.
   */
  void calculateOutput() {
    float tempResult = 0.0;
    
    // Start by calculating the hidden layer node results for each input node
    // For each hidden node Hn:
    //   Hn = sigmoid (wn * in + w(n+1) * i(n+1) ... + Hbias * 1)
    for (int x = 0; x < getNoOfHiddenNodes(); ++x) {
      for (int y = 0; y < getNoOfInputNodes(); ++y) {
        // Sum the results for the weight * input for each input node
        tempResult += inputNodeValues[y] * inputToHiddenWeights[y][x];
        if (verbose) {
          println("i[", y,"] ", inputNodeValues[y], " * ", "iToHW[", y, x,"] ",inputToHiddenWeights[y][x], " += ", tempResult);
        }
      }
      
      // Add bias value result to sum
      tempResult += 1.0 * biasInputToHidden;
      if (verbose) {
        println("Bias: 1.0 * ", biasInputToHidden, " += ", tempResult);
      }
      
      // Squash result using sigmoid of sum 
      hiddenNodeValues[x] = sigmoid(tempResult);
      if (verbose) {
        println("Sigmoid:", hiddenNodeValues[x]);
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
          println("h[", y,"] ", hiddenNodeValues[y], " * ", "hToOW[", y, x,"] ",hiddenToOutputWeights[y][x], " += ", tempResult);
        }
      }
      
      // Add bias value
      tempResult += 1.0 * biasHiddenToOutput;
      if (verbose) {
        println("Bias: 1.0 * ", biasHiddenToOutput, " += ", tempResult);
      }
      
      // Result goes into the output node
      outputNodeValues[x] = sigmoid(tempResult);
      if (verbose) {
        println("Sigmoid:", outputNodeValues[x]);
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
        print("Error o[", x, "]:", tempResult);
        println(" : 0.5 * (", desiredOutputNodeValues[x], "-", outputNodeValues[x],")^2");           
        
      }
    }
    
    if (verbose) {
      println("Total Error: ", tempResult);
    }
    
    totalNetworkError = tempResult;
    
    if (learning) {
      if (verbose) {
        println(">>> Executing learning loop...");
      }
      backPropagation();
      if (verbose) {
        println(">>> Learning loop complete. Epoch = ", learningEpoch);
      }
    }
  }
  
  /* backPropagation()
   * Uses network error to update weights when learning is 
   * enabled.
   */
  private void backPropagation() {
    float totalErrorChangeWRTOutput = 0.0;
    float outputChangeWRTNetInput = 0.0;
    float netInputChangeWRTWeight = 0.0;
    float errorTotalWRTHiddenNode = 0.0;
    //int x = 0;
    
    // Increment epoch
    ++learningEpoch;
    
    // Consider the output layer to calculate new weights for hidden-to-output layer
    //   newWeightN = wn - learningRate * (ErrorTotal / impactOfwn)
    if (verbose) {
      println("Hidden to Output Weight Correction:");
    }
    for (int x = 0; x < getNoOfOutputNodes(); ++x) {
      
      totalErrorChangeWRTOutput = -(desiredOutputNodeValues[x] -  outputNodeValues[x]);
      if (verbose) {
        println("totalErrChangeWRTOutput [", x,"] =", totalErrorChangeWRTOutput);
      }
      
      outputChangeWRTNetInput = outputNodeValues[x] * (1 - outputNodeValues[x]);
      if (verbose) {
        println("outputChangeWRTNetInput [", x,"] =", outputChangeWRTNetInput);
      }
      
      for (int y = 0; y < getNoOfHiddenNodes(); ++y) {
        float weightChange = 0.0;
        
        netInputChangeWRTWeight = hiddenNodeValues[y];
        
        weightChange = totalErrorChangeWRTOutput * outputChangeWRTNetInput * netInputChangeWRTWeight;
        
        if (verbose) {
          println("weightChange =", weightChange, " :", totalErrorChangeWRTOutput, "*", outputChangeWRTNetInput, "*", netInputChangeWRTWeight);
        }
        
        newHiddenToOutputWeights[y][x] = hiddenToOutputWeights[y][x] - (learningRate * weightChange);
                
        if (verbose) {
          println("Calculating", hiddenToOutputWeights[y][x], "-", learningRate, "*", weightChange);
          println("New Weight [", y, x, "] =", newHiddenToOutputWeights[y][x], ", Old Weight =", hiddenToOutputWeights[y][x]);
        }
      }
      
      // Calculate new input-to-hidden weights
      
//      for (int i = 0; i < getNoOfHiddenNodes(); ++i) {
//        errorTotalWRTHiddenNode = 0.0;
//        
//        for (int j = 0; j < getNoOfOutputNodes(); ++j) {
//          // First calculate total error of hidden node with respect to the output nodes and hidden-to-output weights
//          errorTotalWRTHiddenNode += totalErrorChangeWRTOutput * outputChangeWRTNetInput * hiddenToOutputWeights[i][j];
//          
//          if (verbose) {
//            println("Error WRT Hidden Node [", i,"] is", errorTotalWRTHiddenNode);
//          }
//        }
//      }
      
      
      
      
      
    }
    
    // Consider the hidden layer (based upon original weights)
    if (verbose) {
      println("Input to Hidden Weight Correction:");
    }
    
    // Need to consider for each hidden node
    for (int x = 0; x < getNoOfHiddenNodes(); ++x) {
        // For each hidden node we need:
        //   - totalErrorChangeWRTOutput
        //   - outputChangeWRTNetInput
        //   - hiddenToOutputWeights
        float totalErrorChangeWRTHidden = 0.0;
        float outputHiddenWRTnetHidden = 0.0;
        float totalErrorChangeWRTweight = 0.0;
        
        for (int y = 0; y < getNoOfOutputNodes(); ++ y) {
            // totalErrorChangeWRTOutput
            totalErrorChangeWRTOutput = -(desiredOutputNodeValues[y] -  outputNodeValues[y]);
            if (verbose) {
                println("totalErrChangeWRTOutput [", y,"] =", totalErrorChangeWRTOutput);
            }
            
            // outputChangeWRTNetInput
            outputChangeWRTNetInput = outputNodeValues[y] * (1 - outputNodeValues[y]);
            if (verbose) {
                println("outputChangeWRTNetInput [", y,"] =", outputChangeWRTNetInput);
            }
            
            totalErrorChangeWRTHidden += totalErrorChangeWRTOutput * outputChangeWRTNetInput * hiddenToOutputWeights[x][y];
            
            if (verbose) {
                println("totalErrorChangeWRTHidden[", x, "] =", totalErrorChangeWRTHidden);
            }
        }
        
        outputHiddenWRTnetHidden = (hiddenNodeValues[x]) * (1 - hiddenNodeValues[x]);
        
        if (verbose) {
            println("hiddenNodeValues[", x, "] =", hiddenNodeValues[x]);
        }
        
        if (verbose) {
            println("outputHiddenWRTnetHidden[", x, "] =", outputHiddenWRTnetHidden);
        }
        
        // For each input, calculate the weight change
        for (int y = 0; y < getNoOfInputNodes(); ++y) {
            totalErrorChangeWRTweight = totalErrorChangeWRTHidden * outputHiddenWRTnetHidden * inputNodeValues[y];
            
            if (verbose) {
                println("inputNodeValues[", x, "] =", inputNodeValues[x]);
            }
            
            if (verbose) {
                println("totalErrorChangeWRTweight[", x, "] =", totalErrorChangeWRTweight);
            }
            
            newInputToHiddenWeights[y][x] = inputToHiddenWeights[y][x] - (learningRate * totalErrorChangeWRTweight);
            
            if (verbose) {
                println("inputToHiddenWeights[", y, "][", x, "] =", inputToHiddenWeights[y][x]);
                println("newInputToHiddenWeights[", y, "][", x, "] =", newInputToHiddenWeights[y][x]);
            }
        }
    }
    
    
    // Update all weights to newly calculated values
    if (verbose) {
      println("Updating weights.");
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
  
  void setBiasInputToHidden(float bias) {
    biasInputToHidden = bias;
  }
  
  float getBiasInputToHidden() {
    return biasInputToHidden;
  }

  void setBiasHiddenToOutput(float bias) {
    biasHiddenToOutput = bias;
  }
  
  float getBiasHiddenToOutput() {
    return biasHiddenToOutput;
  }
  
  void setLearningRate(float bias) {
    learningRate = bias;
  }
  
  float getLearningRate() {
    return learningRate;
  }
  
  float getTotalNetworkError() {
    return totalNetworkError;
  }
  
  int getNoOfInputNodes() {
    return noOfInputs;
  }
  
  int getNoOfHiddenNodes() {
    return noOfHidden;
  }
  
  int getNoOfOutputNodes() {
    return noOfOutputs;
  }
  
  void setInputNode(int node, float value) {
    inputNodeValues[node] = value;
  }
  
  float getInputNode(int node) {
    return inputNodeValues[node];
  }
  
  void setOutputNodeDesired(int node, float value) {
    desiredOutputNodeValues[node] = value;
  }
  
  float getOutputNodeDesired(int node) {
    return desiredOutputNodeValues[node];
  }
  
  float getOutputNode(int node) {
    return outputNodeValues[node];
  }
  
  void setInputToHiddenWeight(int input, int hidden, float value) {
    inputToHiddenWeights[input][hidden] = value;
  }
  
  float getInputToHiddenWeight(int input, int hidden) {
    return inputToHiddenWeights[input][hidden];
  }
  
  void setHiddenToOutputWeight(int hidden, int output, float value) {
    hiddenToOutputWeights[hidden][output] = value;
  }
  
  float getHiddenToOutputWeight(int hidden, int output) {
    return hiddenToOutputWeights[hidden][output];
  }
  
  int getEpoch() {
      return learningEpoch;
  }
  
  void turnLearningOn() {
    learning = true;
    // Also reset learning epoch
    learningEpoch = 0;
  }
  
  void turnLearningOff() {
    learning = false;
  }
  
  void turnVerboseOn() {
    verbose = true;
  }
  
  void turnVerboseOff() {
    verbose = false;
  }
  
  boolean getLearningStatus() {
    return learning;
  }
  
  void displayInputNodes() {
    for (int x = 0; x < noOfInputs; ++x) {
      print(getInputNode(x), " ");
    }
    println();
  }
  
  void displayInputToHiddenWeightsCurrent() {
    for (int x = 0; x < getNoOfInputNodes(); ++x) {
      print("For Input Node " + x + ": ");
      for (int y = 0; y < getNoOfHiddenNodes(); ++y) {
        print(inputToHiddenWeights[x][y], " ");
      }
      println();
    }
  }
  
  void displayHiddenToOutputWeightsCurrent() {
    for (int x = 0; x < getNoOfHiddenNodes(); ++x) {
      print("For Hidden Node " + x + ": ");
      for (int y = 0; y < getNoOfOutputNodes(); ++y) {
        print(hiddenToOutputWeights[x][y], " ");
      }
      println();
    }
  }
  
  void displayHiddenNodes() {
    for (int x = 0; x < getNoOfHiddenNodes(); ++x) {
      print(hiddenNodeValues[x], " ");
    }
    println();
  }
  
  void displayOutputNodes() {
    for (int x = 0; x < getNoOfOutputNodes(); ++x) {
      print(outputNodeValues[x], " ");
    }
    println();
  }
  
  void seed(int x) {
    randomSeed(x);
  }
}

float sigmoid(float x) {
  return (1 / (1 + exp(-x)));
}

float derivativeSigmoid(float x) {
  return (sigmoid(x) * (1 - sigmoid(x)));
}