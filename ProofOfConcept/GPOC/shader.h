#ifndef SHADER_H
#define SHADER_H

#include <glad/glad.h>

#include <vector>
#include <string>

struct DEFINE {
    std::string key;
    std::string value;
};

GLuint ShaderProgram(std::string file_vertex, std::string file_fragment, std::vector<DEFINE>* precompile=nullptr);

#endif
