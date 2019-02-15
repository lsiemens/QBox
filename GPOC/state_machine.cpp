#include "state_machine.h"

#include <iostream>
#include <sstream>

#include "resource_manager.h"
#include "text_renderer.h"
#include "sprite_renderer.h"

SpriteRenderer* Renderer;
TextRenderer* Text;

StateMachine::StateMachine(GLuint width, GLuint height)
    : State(STATE_EIGENVECTOR), Keys(), Width(width), Height(height), fps(0.0f), fps_smoothing(0.9f) { }

StateMachine::~StateMachine() {
    delete Renderer;
    delete Text;
}

void StateMachine::Init() {
    // Load shaders
    ResourceManager::LoadShader("shaders/sprite.vert", "shaders/sprite.frag", nullptr, "sprite");
    ResourceManager::LoadShader("shaders/text.vert", "shaders/text.frag", nullptr, "text");

    // Load Textures
    ResourceManager::LoadTexture("textures/background.jpg", "background");

    // pass data to GPU glUniform
    glm::mat4 projection = glm::ortho(0.0f, static_cast<GLfloat>(this->Width), static_cast<GLfloat>(this->Height), 0.0f, -1.0f, 1.0f);
    ResourceManager::GetShader("sprite").Uniform1("image", 0, GL_TRUE);
    ResourceManager::GetShader("sprite").Uniform4x4("projection", projection);
    ResourceManager::GetShader("text").Uniform1("image", 0, GL_TRUE);
    ResourceManager::GetShader("text").Uniform4x4("projection", projection);

    Renderer = new SpriteRenderer(ResourceManager::GetShader("sprite"));
    Text = new TextRenderer(this->Width, this->Height, ResourceManager::GetShader("text"));
    Text->Load("fonts/OCRAEXT.TTF", 24);
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
    Renderer->DrawSprite(ResourceManager::GetTexture("background"), glm::vec2(0, 0), glm::vec2(this->Width, this->Height), 0.0f);

    // dont include the text in the postprocessing
    if (this->State == STATE_EIGENVECTOR) {
        Text->RenderText("Press ENTER to switch", 250.0f, this->Height / 2, 1.0f);
    }

    if (this->State == STATE_TIME_EVOLUTION) {
        std::stringstream stream_lives; stream_lives << this->fps;
        Text->RenderText("FPS:" + stream_lives.str(), 5.0f, 5.0f, 1.0f);
    }
}
