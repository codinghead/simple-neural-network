/*
  neural.h - Library for Neural Network.
  Created by Stuart Cording, Sept 9th, 2017.
  Released into the public domain.
*/
#ifndef Neural_h
#define Neural_h

#include "Arduino.h"

class Neural
{
    private:
        double* inputNodeValues;
        double* hiddenNodeValues;
        double* outputNodeValues;
        double* desiredOutputNodeValues;
        int noOfInputs;
        int noOfHidden;
        int noOfOutputs;

        double** inputToHiddenWeights;
        double** newInputToHiddenWeights;
        double** hiddenToOutputWeights;
        double** newHiddenToOutputWeights;

        double biasInputToHidden;
        double biasHiddenToOutput;
        double learningRate;
        double totalNetworkError;
        int learningEpoch;

        boolean learning;

        boolean verbose;
        
        void    _backPropagation();
    
    public:
        Neural(int inputs, int hidden, int outputs);
        void    calculateOutput();
        
        void    setLearningRate(double bias);
        double  getLearningRate();
        void    setBiasInputToHidden(double bias);
        double  getBiasInputToHidden();
        void    setBiasHiddenToOutput(double bias);
        double  getBiasHiddenToOutput();
        void    turnLearningOn();
        void    turnLearningOff();
        void    setInputNode(int node, double value);
        double  getInputNode(int node);
        void    setOutputNodeDesired(int node, double value);
        double  getOutputNodeDesired(int node);
        int     getNoOfInputNodes();
        int     getNoOfHiddenNodes();
        int     getNoOfOutputNodes();
        double  getOutputNode(int node);
        void    displayInputToHiddenWeightsCurrent();
        void    displayHiddenToOutputWeightsCurrent();
        void    turnVerboseOn();
        void    turnVerboseOff();
        double  getTotalNetworkError();
        int     getEpoch();
        void    setInputToHiddenWeight(int input, int hidden, double value);
        double  getInputToHiddenWeight(int input, int hidden);
        void    setHiddenToOutputWeight(int hidden, int output, double value);
        double  getHiddenToOutputWeight(int hidden, int output);
        boolean getLearningStatus();
        void    displayInputNodes();
        void    displayHiddenNodes();
        void    displayOutputNodes();
};

#endif