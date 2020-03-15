#include "text_renderer.h"

#include <iostream>

#include <glm/gtc/type_ptr.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <ft2build.h>
#include FT_FREETYPE_H

TextRenderer::TextRenderer(GLuint width, GLuint height) {

    this->shader_program = ShaderProgram("shaders/text.vert", "shaders/text.frag");
    glm::mat4 projection = glm::ortho(0.0f, static_cast<GLfloat>(width), static_cast<GLfloat>(height), 0.0f);

    glUseProgram(this->shader_program);
    glUniformMatrix4fv(glGetUniformLocation(this->shader_program, "projection"), 1, GL_FALSE, glm::value_ptr(projection));
    glUniform1i(glGetUniformLocation(this->shader_program, "text"), 0);

    glGenVertexArrays(1, &this->VAO);
    glGenBuffers(1, &this->VBO);
    glBindVertexArray(this->VAO);
    glBindBuffer(GL_ARRAY_BUFFER, this->VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*6*4, NULL, GL_DYNAMIC_DRAW);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 4*sizeof(GLfloat), 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
}

void TextRenderer::Load(std::string font, GLuint font_size) {
    this->characters.clear();

    FT_Library freetype;
    if (FT_Init_FreeType(&freetype))
        std::cout << "ERROR::FREETYPE:\n\tFailed to load Freetype2" << std::endl;

    FT_Face type_face;
    if (FT_New_Face(freetype, font.c_str(), 0, &type_face))
        std::cout << "ERROR::FREETYPE:\n\tFailed to load font: " << font << std::endl;

    FT_Set_Pixel_Sizes(type_face, 0, font_size);
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);

    for (GLubyte c = 0; c < 128; c++) {
        if (FT_Load_Char(type_face, c, FT_LOAD_RENDER)) {
            std::cout << "ERROR::FREETYTPE:\n\tFailed to load Glyph" << std::endl;
            continue;
        }
        GLuint texture_handel;
        Character character = {texture_handel, glm::vec2(type_face->glyph->advance.x, type_face->glyph->advance.y),
                               glm::vec2(type_face->glyph->bitmap.width, type_face->glyph->bitmap.rows),
                               glm::vec2(type_face->glyph->bitmap_left, type_face->glyph->bitmap_top)};

        glGenTextures(1, &character.texture_handel);
        glBindTexture(GL_TEXTURE_2D, character.texture_handel);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RED, character.Size.x, character.Size.y, 0, GL_RED, GL_UNSIGNED_BYTE, type_face->glyph->bitmap.buffer);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        characters.insert(std::pair<GLchar, Character>(c, character));
    }
    glBindTexture(GL_TEXTURE_2D, 0);

    FT_Done_Face(type_face);
    FT_Done_FreeType(freetype);
}

void TextRenderer::RenderText(std::string text, glm::vec2 pos, GLfloat scale, glm::vec3 color) {
    glUseProgram(this->shader_program);
    glUniform3fv(glGetUniformLocation(this->shader_program, "text_color"), 1, glm::value_ptr(color));
    glActiveTexture(GL_TEXTURE0);
    glBindVertexArray(this->VAO);

    std::string::const_iterator c;
    for (c = text.begin(); c != text.end(); c++) {
        Character ch = this->characters[*c];

        glm::vec2 character_pos = pos + (this->characters['A'].Bearing - ch.Bearing)*scale;
        glm::vec2 character_offset = ch.Size*scale;

        GLfloat vertices[] = {
            character_pos.x, character_pos.y + character_offset.y, 0.0, 1.0,
            character_pos.x + character_offset.x, character_pos.y, 1.0, 0.0,
            character_pos.x, character_pos.y, 0.0, 0.0,

            character_pos.x, character_pos.y + character_offset.y, 0.0, 1.0,
            character_pos.x + character_offset.x, character_pos.y + character_offset.y, 1.0, 1.0,
            character_pos.x + character_offset.x, character_pos.y, 1.0, 0.0 };

        glBindTexture(GL_TEXTURE_2D, ch.texture_handel);

        glBindBuffer(GL_ARRAY_BUFFER, this->VBO);
        glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(vertices), vertices);

        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glDrawArrays(GL_TRIANGLES, 0, 6);
        pos += ch.Advance*scale/64.0f;
    }
    glBindVertexArray(0);
    glBindTexture(GL_TEXTURE_2D, 0);
}
