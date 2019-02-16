#include "shader.h"

#include <iostream>
#include <fstream>
#include <sstream>

GLuint compile_shader(std::string file, GLuint type);

GLuint ShaderProgram(std::string file_vertex, std::string file_fragment) {
    GLuint vertex_shader_handel = compile_shader(file_vertex, GL_VERTEX_SHADER);
    GLuint fragment_shader_handel = compile_shader(file_fragment, GL_FRAGMENT_SHADER);

    GLuint program = glCreateProgram();
    glAttachShader(program, vertex_shader_handel);
    glAttachShader(program, fragment_shader_handel);
    glLinkProgram(program);

    GLint linked, log_length;
    glGetProgramiv(program, GL_LINK_STATUS, &linked);
    glGetProgramiv(program, GL_INFO_LOG_LENGTH, &log_length);

    if (!linked) {
        GLchar* log = new GLchar[log_length + 1];
        glGetProgramInfoLog(program, log_length, NULL, log);
        std::cout << "ERROR::SHADER::PROGRAM::LINK\n\t " << log << std::endl;
        delete[] log;
    }

    glDeleteShader(vertex_shader_handel);
    glDeleteShader(fragment_shader_handel);

    return program;
}

GLuint compile_shader(std::string file, GLuint type) {
    std::stringstream sstr;
    std::string temp_shader_source;
    std::ifstream fin;
    fin.exceptions(std::ifstream::badbit | std::ifstream::failbit);
    try {
        fin.open(file, std::ios::in);
        sstr << fin.rdbuf();
        temp_shader_source = sstr.str();
    } catch (std::ifstream::failure e) {
        std::cout << "ERROR: Vertex shader failed to load: " << file << std::endl;
    }
    const GLchar* shader_code = temp_shader_source.c_str();

    GLuint shader_handel = glCreateShader(type);
    glShaderSource(shader_handel, 1, &shader_code, NULL);
    glCompileShader(shader_handel);

    GLint compiled, log_length;
    glGetShaderiv(shader_handel, GL_COMPILE_STATUS, &compiled);
    glGetShaderiv(shader_handel, GL_INFO_LOG_LENGTH, &log_length);

    if (!compiled) {
        GLchar* log = new GLchar[log_length + 1];
        glGetShaderInfoLog(shader_handel, log_length, NULL, log);
        switch (type) {
            case GL_VERTEX_SHADER:
                std::cout << "ERROR::SHADER::VERTEX::COMPILE: " << file << "\n\t " << log << std::endl;
                break;
            case GL_GEOMETRY_SHADER:
                std::cout << "ERROR::SHADER::GEOMETRY::COMPILE: " << file << "\n\t " << log << std::endl;
                break;
            case GL_FRAGMENT_SHADER:
                std::cout << "ERROR::SHADER::FRAGMENT::COMPILE: " << file << "\n\t " << log << std::endl;
                break;
        }
        delete[] log;
    }

    return shader_handel;
}
