#ifndef STATE_MACHINE_H
#define STATE_MACHINE_H

#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <glm/glm.hpp>

enum InternalState {
    STATE_EIGENVECTOR,
    STATE_TIME_EVOLUTION,
};

class StateMachine {
public:
    // State variables
    InternalState State;
    GLboolean Keys[1024];
    GLboolean KeysRegistered[1024];
    GLuint Width, Height;
    GLfloat fps;

    // class constructor destructor
    StateMachine(GLuint width, GLuint height);
    ~StateMachine();

    // Initalize game and assets
    void Init();

    // Main loop functions
    void ProcessInput(GLfloat dt);
    void Update(GLfloat dt);
    void Render();
private:
    const GLfloat fps_smoothing;
};

#endif
