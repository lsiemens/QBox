#ifndef SHADER_H
#define SHADER_H

#include <glad/glad.h>

#include <string>

GLuint ShaderProgram(std::string file_vertex, std::string file_fragment);

#endif
