#ifndef SHADER_H
#define SHADER_H

#include <string>

#include <glad/glad.h>
#include <glm/glm.hpp>
#include <glm/gtc/type_ptr.hpp>

// Arbitray shader class
class Shader {
public:
    // State variables
    GLuint ID;

    Shader() { }

    void Use();

    // Compile shaders from source
    void Compile(const GLchar* vertexSource, const GLchar* fragmentSource, const GLchar* geometrySource=nullptr);

    // data transfer (glUniform)
    void Uniform1(const GLchar* name, GLfloat value, GLboolean useShader=false);
    void Uniform1(const GLchar* name, GLint value, GLboolean useShader=false);
    void Uniform2(const GLchar* name, const glm::vec2 &value, GLboolean useShader=false);
    void Uniform3(const GLchar* name, const glm::vec3 &value, GLboolean useShader=false);
    void Uniform4(const GLchar* name, const glm::vec4 &value, GLboolean useShader=false);
    void Uniform4x4(const GLchar* name, const glm::mat4 &matrix, GLboolean useShader=false);

private:
    // private variables
    static const unsigned int infoLogLen = 1024;

    // check GLSL compile and linking errors
    void checkCompileErrors(GLuint object, std::string type);
};

#endif
