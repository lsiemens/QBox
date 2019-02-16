#include "QBox_POC.h"

#include <cstring>
#include <iostream>
#include <fstream>

DQBox::DQBox(std::string file) {
    char cheader[this->HEADER_SIZE*sizeof(int)];
    int header[this->HEADER_SIZE];

    char* cbuffer = NULL;
    unsigned int buffer_size=0;
    std::ifstream fin(file, std::ios::in | std::ios::binary);
    if (fin.is_open()) {
        fin.read(cheader, this->HEADER_SIZE*sizeof(int));
        std::memcpy(header, cheader, this->HEADER_SIZE*sizeof(int));
        if (header[0] != this->ID)
            std::cout << "ERROR file is corrupted" << std::endl;
        this->num = header[1];
        this->n = header[2];

        buffer_size = this->n*this->n*this->num;
        cbuffer = new char[buffer_size*sizeof(float)];
        this->state = new float[buffer_size];
        fin.read(cbuffer, buffer_size*sizeof(float));
        std::memcpy(this->state, cbuffer, buffer_size*sizeof(float));
        delete cbuffer;

        buffer_size = this->num;
        cbuffer = new char[buffer_size*sizeof(float)];
        this->energy = new float[buffer_size];
        fin.read(cbuffer, buffer_size*sizeof(float));
        std::memcpy(this->energy, cbuffer, buffer_size*sizeof(float));
        delete cbuffer;
    } else {
        std::cout << "ERROR could not open file: " << file << std::endl;
    }
    this->initalize_ranges();
}

void DQBox::initalize_ranges() {
    this->state_range = new float[this->num];
    int offset = this->n*this->n;
    float min, max;
    for (int i=0; i < this->num; i++) {
        min = 0.0;
        for (int j=0; j < offset; j++) {
            if (this->state[j + offset*i] > max)
                max = this->state[j + offset*i];

            if (this->state[j + offset*i] < -max)
                max = -this->state[j + offset*i];
        }
        this->state_range[i] = max;
    }
}
