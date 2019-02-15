#include "shader.h"

#include <iostream>

void Shader::Use() {
    glUseProgram(this->ID);
}

void Shader::Compile(const GLchar* vertexSource, const GLchar* fragmentSource, const GLchar* geometrySource) {
    GLuint sVertex, sFragment, sGeometry;

    // setup and compile vertex shader
    sVertex = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(sVertex, 1, &vertexSource, NULL);
    glCompileShader(sVertex);
    checkCompileErrors(sVertex, "VERTEX");

    // setup and compile fragment shader
    sFragment = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(sFragment, 1, &fragmentSource, NULL);
    glCompileShader(sFragment);
    checkCompileErrors(sFragment, "FRAGMENT");

    // setup and compile fragment shader if applicable
    if (geometrySource != nullptr) {
        sGeometry = glCreateShader(GL_GEOMETRY_SHADER);
        glShaderSource(sGeometry, 1, &geometrySource, NULL);
        glCompileShader(sGeometry);
        checkCompileErrors(sGeometry, "Geometry");
    }

    // setup shader program
    this->ID = glCreateProgram();
    glAttachShader(this->ID, sVertex);
    glAttachShader(this->ID, sFragment);
    if (geometrySource != nullptr)
        glAttachShader(this->ID, sGeometry);
    glLinkProgram(this->ID);
    checkCompileErrors(this->ID, "PROGRAM");

    // cleanup linked shaders
    glDeleteShader(sVertex);
    glDeleteShader(sFragment);
    if (geometrySource != nullptr)
        glDeleteShader(sGeometry);
}

void Shader::Uniform1(const GLchar* name, GLfloat value, GLboolean useShader) {
    if (useShader)
        this->Use();
    glUniform1f(glGetUniformLocation(this->ID, name), value);
}

void Shader::Uniform1(const GLchar* name, GLint value, GLboolean useShader) {
    if (useShader)
        this->Use();
    glUniform1i(glGetUniformLocation(this->ID, name), value);
}

void Shader::Uniform2(const GLchar* name, const glm::vec2 &value, GLboolean useShader) {
    if (useShader)
        this->Use();
    glUniform2f(glGetUniformLocation(this->ID, name), value.x, value.y);
}

void Shader::Uniform3(const GLchar* name, const glm::vec3 &value, GLboolean useShader) {
    if (useShader)
        this->Use();
    glUniform3f(glGetUniformLocation(this->ID, name), value.x, value.y, value.z);
}

void Shader::Uniform4(const GLchar* name, const glm::vec4 &value, GLboolean useShader) {
    if (useShader)
        this->Use();
    glUniform4f(glGetUniformLocation(this->ID, name), value.x, value.y, value.z, value.w);
}

void Shader::Uniform4x4(const GLchar* name, const glm::mat4 &matrix, GLboolean useShader) {
    if (useShader)
        this->Use();
    glUniformMatrix4fv(glGetUniformLocation(this->ID, name), 1, GL_FALSE, glm::value_ptr(matrix));
}

void Shader::checkCompileErrors(GLuint object, std::string type) {
    GLint success;
    GLchar infoLog[this->infoLogLen];
    if (type != "PROGRAM") {
        glGetShaderiv(object, GL_COMPILE_STATUS, &success);
        if (!success) {
            glGetShaderInfoLog(object, this->infoLogLen, NULL, infoLog);
            std::cout << "| ERROR::SHADER: Compile-time error: Type: " << type << "\n"
                << infoLog << "\n -- --------------------------------------------------- -- "
                << std::endl;
        }
    } else {
        glGetProgramiv(object, GL_LINK_STATUS, &success);
        if (!success) {
            glGetShaderInfoLog(object, this->infoLogLen, NULL, infoLog);
            std::cout << "| ERROR::SHADER: Link-time error: Type: " << type << "\n"
                << infoLog << "\n -- --------------------------------------------------- -- "
                << std::endl;
        }
    }
}
