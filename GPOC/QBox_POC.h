#ifndef QBOX_POC_H
#define QBOX_POC_H

#include <string>

class DQBox {
public:
    int num;
    int n;
    float* state; // data[i + n*j + n*n*k] = state[i][j][k], in numpy notation state[:, :, n] is the nth wave function
    float* energy;

    DQBox(std::string file);
private:
    static const int ID=2020557393; // QBox as an int
    static const int HEADER_SIZE = 3;
};

#endif
