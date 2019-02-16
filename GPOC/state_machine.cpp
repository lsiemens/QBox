#include "state_machine.h"

#include <iostream>

#include "QBox_POC.h"
#include "shader.h"

DQBox* QBox;

StateMachine::StateMachine(GLuint width, GLuint height)
    : State(STATE_EIGENVECTOR), Keys(), Width(width), Height(height), fps(0.0f), fps_smoothing(0.9f) { }

StateMachine::~StateMachine() {
}

void StateMachine::Init() {
    QBox = new DQBox("test.raw");

    this->shader_program = ShaderProgram("shaders/sprite.vert", "shaders/sprite.frag");

    float quad[] = {0.9f, -0.9f, 1.0f, 0.0f,
                    0.9f, 0.9f, 1.0f, 1.0f,
                    -0.9f, -0.9f, 0.0f, 0.0f,

                    -0.9f, -0.9f, 0.0f, 0.0f,
                    0.9f, 0.9f, 1.0f, 1.0f,
                    -0.9f, 0.9f, 0.0f, 1.0f};

    GLuint VBO;
    glGenVertexArrays(1, &this->VAO);
    glGenBuffers(1, &VBO);
    glBindVertexArray(this->VAO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(quad), quad, GL_STATIC_DRAW);
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, (void*)0);
    glEnableVertexAttribArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);

    glGenTextures(1, &this->texture_handel);
    glBindTexture(GL_TEXTURE_2D_ARRAY, this->texture_handel);
    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

    GLuint width, height, depth, num_channels;
    width = 100;
    height = 100;
    depth = 3;
    GLfloat* data = new GLfloat[width*height*depth];
    for (int i = 0; i < width*height*num_channels; i++) {
        data[i] = cos(3.14f*i/10.0f);
    }

    glTexImage3D(GL_TEXTURE_2D_ARRAY, 0, GL_R32F, width, height, depth, 0, GL_RED, GL_FLOAT, data);
    glBindTexture(GL_TEXTURE_2D_ARRAY, 0);

    glUseProgram(this->shader_program);
    glUniform1i(glGetUniformLocation(this->shader_program, "texture0"), 0);
}

void StateMachine::ProcessInput(GLfloat dt) {
    if (this->State == STATE_EIGENVECTOR) {
        if (this->Keys[GLFW_KEY_ENTER] && !KeysRegistered[GLFW_KEY_ENTER]) {
            this->State = STATE_TIME_EVOLUTION;
            this->KeysRegistered[GLFW_KEY_ENTER] = GL_TRUE;
        }
    } else if (this->State == STATE_TIME_EVOLUTION) {
        if (this->Keys[GLFW_KEY_ENTER] && !KeysRegistered[GLFW_KEY_ENTER]) {
            this->State = STATE_EIGENVECTOR;
            this->KeysRegistered[GLFW_KEY_ENTER] = GL_TRUE;
        }
    }
}

void StateMachine::Update(GLfloat dt) {
    //calculate exponentaly smoothed FPS
    this->fps = this->fps*this->fps_smoothing + (1.0f - this->fps_smoothing)/dt;
}

void StateMachine::Render() {
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D_ARRAY, this->texture_handel);

    glUseProgram(this->shader_program);
    glBindVertexArray(this->VAO);
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

