#ifndef TEXT_RENDERER_H
#define TEXT_RENDERER_H

#include <map>
#include <glad/glad.h>
#include <glm/glm.hpp>

#include "shader.h"

struct Character {
    GLuint texture_handel;
    glm::vec2 Advance;
    glm::vec2 Size;
    glm::vec2 Bearing;
};

class TextRenderer {
public:
    std::map<GLchar, Character> characters;
    GLuint VAO, VBO, shader_program;

    TextRenderer(GLuint width, GLuint height);

    void Load(std::string font, GLuint fontSize);
    void RenderText(std::string text, glm::vec2 pos, GLfloat scale, glm::vec3 color=glm::vec3(1.0f));
private:
};

#endif
