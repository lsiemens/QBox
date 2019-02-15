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
//        std::cout << "num: " << num << " n: " << n << " file size: " << 4*3 + 4*this->n*this->n*2*this->num + 4*this->num << std::endl;

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

//        for (int i = 0; i < this->num; i++)
//            std::cout << this->energy[i] << " ";
//        std::cout << std::endl;
    } else {
        std::cout << "ERROR could not open file: " << file << std::endl;
    }
}




/*
int main() {
    std::ifstream fin("test.dat", std::ios::in | std::ios::binary);
    char cheader[3*sizeof(int)];
    char* cdata;
    int header[3];
    float* data;
    int id, num, n;
    if (fin.is_open()) {
        fin.read(cheader, 3*sizeof(int));
    } else {
        return -1;
    }
    std::memcpy(header, cheader, 3*sizeof(int));
    id = header[0];
    num = header[1];
    n = header[2];

    std::cout << "id: " << id << " num " << num << " n " << n << std::endl;

    cdata = new char[2*n*n*sizeof(float)];
    data = new float[2*n*n];
    if (fin.is_open()) {
        fin.read(cdata, 2*n*n*sizeof(float));
    } else {
        return -1;
    }
    std::memcpy(data, cdata, n*n*sizeof(float));

    cdata = new char[1*sizeof(float)];
    data = new float[1];
    if (fin.is_open()) {
        fin.read(cdata, 1*sizeof(float));
    } else {
        return -1;
    }
    std::memcpy(data, cdata, 1*sizeof(float));
    for (int i=0; i < 1; i++) {
        std::cout << data[i] << " ";
    }
    std::cout << std::endl;
    return 0;
}
*/
