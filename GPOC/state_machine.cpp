#include "state_machine.h"

#include <sstream>
#include <iostream>

#include "QBox_POC.h"
#include "shader.h"
#include "text_renderer.h"

DQBox* QBox;
TextRenderer* Text;

StateMachine::StateMachine(GLuint width, GLuint height)
    : State(STATE_EIGENVECTOR), Keys(), Width(width), Height(height), fps(0.0f), fps_smoothing(0.99f) { }

StateMachine::~StateMachine() {
}

void StateMachine::Init() {
    QBox = new DQBox("test.raw");
    Text = new TextRenderer(this->Width, this->Height);
    Text->Load("fonts/LeagueGothic-Regular.otf", 24);

    this->shader_program = ShaderProgram("shaders/sprite.vert", "shaders/sprite.frag");

    GLfloat quad[] = {0.9f, 0.9f, 1.0f, 0.0f,
                    0.9f, -0.9f, 1.0f, 1.0f,
                    -0.9f, 0.9f, 0.0f, 0.0f,

                    -0.9f, 0.9f, 0.0f, 0.0f,
                    0.9f, -0.9f, 1.0f, 1.0f,
                    -0.9f, -0.9f, 0.0f, 1.0f};

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
    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    GLuint width, height, depth;
    width = QBox->n;
    height = QBox->n;
    depth = QBox->num;

    float max = 0;
    for (int i = 0; i < width*height*depth; i++) {
        if (QBox->state[i] > max) {
            max = QBox->state[i];
        }
    }
    std::cout << "max " << max << std::endl;

    glTexImage3D(GL_TEXTURE_2D_ARRAY, 0, GL_R32F, width, height, depth, 0, GL_RED, GL_FLOAT, QBox->state);
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

    std::stringstream stream_fps;
    stream_fps.precision(1);
    stream_fps << std::fixed << this->fps;
    Text->RenderText("FPS: " + stream_fps.str(), glm::vec2(10.0f, 5.0f), 1.0f);

    if (this->State == STATE_EIGENVECTOR)
        Text->RenderText("Press ENTER to switch mode: Eigenvectors", glm::vec2(150.0f, 5.0f), 1.0f);
    if (this->State == STATE_TIME_EVOLUTION)
        Text->RenderText("Press ENTER to switch mode: Time evolution", glm::vec2(150.0f, 5.0f), 1.0f);
}

