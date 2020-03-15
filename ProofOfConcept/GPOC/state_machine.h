#ifndef STATE_MACHINE_H
#define STATE_MACHINE_H

#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <glm/glm.hpp>

enum InternalState {
    STATE_EIGENVECTOR,
    STATE_PRE_TIME_EVOLUTION,
    STATE_TIME_EVOLUTION,
};

class StateMachine {
public:
    // State variables
    InternalState State;
    glm::vec2 mouse_pos;
    GLboolean Keys[1024];
    GLboolean KeysRegistered[1024];
    GLboolean Button_mouse[8];
    GLboolean Button_mouseRegistered[8];
    GLuint Width, Height;
    GLfloat fps;

    // GLvariables
    GLuint wave_function_shader, probability_density_shader;
    GLuint shader_program, VAO, texture_handel;

    // shader parameters
    GLfloat shader_range;
    GLint qstate_id;

    // time evolution
    GLfloat time;
    glm::vec2* qcoefficients;
    glm::vec2* inital_wave_function;

    // class constructor destructor
    StateMachine(GLuint width, GLuint height);
    ~StateMachine();

    // Initalize game and assets
    void Init();

    // Main loop functions
    void ProcessInput(GLfloat dt);
    void Update(GLfloat dt);
    void Render();

    void ProcessScroll(glm::vec2 mouse_scroll_offset);
private:
    const GLfloat fps_smoothing, mouse_scroll_sensifivity;
};

#endif
