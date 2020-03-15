#ifndef QBOX_POC_H
#define QBOX_POC_H

#include <glm/glm.hpp>

#include <string>

class DQBox {
public:
    int num;
    int n;
    float* state; // data[i + n*j + n*n*k] = state[i][j][k], in numpy notation state[:, :, n] is the nth wave function
    float* energy;
    float* state_range; // max(abs(state[i])), render states either on [0, state_range] or [-state_range, state_range]

    DQBox(std::string file);

    void normalize(glm::vec2* qcoefficients);

    void find_coefficients(glm::vec2* wave_function, glm::vec2* qcoefficients);
private:
    static const int ID=2020557393; // QBox as an int
    static const int HEADER_SIZE = 3;

    void initalize();
    void initalize_ranges();
};

#endif
