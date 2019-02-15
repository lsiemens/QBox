#include "sprite_renderer.h"

SpriteRenderer::SpriteRenderer(const Shader &shader) {
    this->shader = shader;
    this->initRenderData();
}

SpriteRenderer::~SpriteRenderer() {
    glDeleteVertexArrays(1, &this->quadVAO);
}

void SpriteRenderer::DrawSprite(const Texture2D &texture, glm::vec2 position, glm::vec2 size, GLfloat rotate, glm::vec3 color) {

    // initalize trasformation matricies
    this->shader.Use();
    glm::mat4 model(1.0f);

    model = glm::translate(model, glm::vec3(position, 0.0f)); // move sprite to position

    model = glm::translate(model, glm::vec3(0.5f*size.x, 0.5f*size.y, 0.0f)); // return origin to the default position
    model = glm::rotate(model, rotate, glm::vec3(0.0f, 0.0f, 1.0f)); // rotate about sprite center
    model = glm::translate(model, glm::vec3(-0.5f*size.x, -0.5f*size.y, 0.0f)); // set orgin to center

    model = glm::scale(model, glm::vec3(size, 1.0f)); // scale

    // send uniform data to GPU
    this->shader.Uniform4x4("model", model);
    this->shader.Uniform3("spriteColor", color);

    // set active texture
    glActiveTexture(GL_TEXTURE0);
    texture.Bind();

    // draw sprite
    glBindVertexArray(this->quadVAO);
    glDrawArrays(GL_TRIANGLES, 0, 6);
    glBindVertexArray(0);
}

void SpriteRenderer::initRenderData() {
    // initalize Array Objects and Buffer Objects
    GLuint VBO;

    GLfloat vertices[] = {
    // data layout
    // pos.x,pos.y,tex.x,tex.y
        0.0f, 1.0f, 0.0f, 1.0f,
        1.0f, 0.0f, 1.0f, 0.0f,
        0.0f, 0.0f, 0.0f, 0.0f,

        0.0f, 1.0f, 0.0f, 1.0f,
        1.0f, 1.0f, 1.0f, 1.0f,
        1.0f, 0.0f, 1.0f, 0.0f
    };

    // get Object indices from OpenGL
    glGenVertexArrays(1, &this->quadVAO);
    glGenBuffers(1, &VBO);

    // load vertex buffer object
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    // tell the shader how to unpack vertices
    glBindVertexArray(this->quadVAO);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 4*sizeof(GLfloat), (GLvoid*)0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
}
