#include "state_machine.h"

#include <iostream>
#include <sstream>

#include "QBox_POC.h"

DQBox* QBox;

StateMachine::StateMachine(GLuint width, GLuint height)
    : State(STATE_EIGENVECTOR), Keys(), Width(width), Height(height), fps(0.0f), fps_smoothing(0.9f) { }

StateMachine::~StateMachine() {
}

void StateMachine::Init() {
    QBox = new DQBox("test.raw");
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
}
