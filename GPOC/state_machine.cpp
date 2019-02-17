#include "state_machine.h"

#include <sstream>
#include <iostream>

#include <glm/gtc/type_ptr.hpp>

#include "QBox_POC.h"
#include "shader.h"
#include "text_renderer.h"

DQBox* QBox;
TextRenderer* Text;


GLfloat gausian_width = 6.0f;

StateMachine::StateMachine(GLuint width, GLuint height)
    : Keys(), Width(width), Height(height), fps(0.0f), fps_smoothing(0.9f), time(0.0f), mouse_scroll_sensifivity(0.1f){ }

StateMachine::~StateMachine() {
}

void StateMachine::Init() {
    QBox = new DQBox("test.raw");

    // fast upto 32
//    QBox->num = 32; // ----------------------------------------------------------------------- theck for unrolling since fram drops by order of magniture after one more energy level

    Text = new TextRenderer(this->Width, this->Height);
    Text->Load("fonts/LeagueGothic-Regular.otf", 24);

    DEFINE precompile_num_states = {"num_states", std::to_string(QBox->num)};
    std::vector<DEFINE> precompile{precompile_num_states};

    this->wave_function_shader = ShaderProgram("shaders/sprite.vert", "shaders/wave_function.frag");
    this->probability_density_shader = ShaderProgram("shaders/sprite.vert", "shaders/probability_density.frag", &precompile);

    // initalize active shader
    this->State = STATE_EIGENVECTOR;
    this->shader_program = this->wave_function_shader;
    this->qstate_id = 0;
    this->shader_range = QBox->state_range[this->qstate_id];
    this->qcoefficients = new glm::vec2[QBox->num];
    this->inital_wave_function = new glm::vec2[QBox->n*QBox->n];

    for (int i=0; i < QBox->num; i++) {
       this->qcoefficients[i] = glm::vec2(1.0f);
    }

    for (int i=0; i < QBox->n*QBox->n; i++) {
        this->inital_wave_function[i] = glm::vec2(1.0f);
    }

    QBox->normalize(this->qcoefficients);

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

    glTexImage3D(GL_TEXTURE_2D_ARRAY, 0, GL_R32F, width, height, depth, 0, GL_RED, GL_FLOAT, QBox->state);
    glBindTexture(GL_TEXTURE_2D_ARRAY, 0);

    glUseProgram(this->wave_function_shader);
    glUniform1i(glGetUniformLocation(this->wave_function_shader, "texture0"), 0);
    glUseProgram(this->probability_density_shader);
    glUniform1i(glGetUniformLocation(this->probability_density_shader, "texture0"), 0);
    glUniform1fv(glGetUniformLocation(this->probability_density_shader, "energy"), QBox->num, QBox->energy);
}

void StateMachine::ProcessInput(GLfloat dt) {
    if (this->State == STATE_EIGENVECTOR) {
        if (this->Keys[GLFW_KEY_ENTER] && !this->KeysRegistered[GLFW_KEY_ENTER]) {
            this->State = STATE_PRE_TIME_EVOLUTION;
            this->shader_program = this->probability_density_shader;
            this->time = 0.0f;

/*            int offset = QBox->n*QBox->n;
            glm::vec2* data = new glm::vec2[offset];
            for (int i = 0; i < offset; i++) {
                glm::vec2 value = glm::vec2(0.0f, 0.0f);
                for (int j = 0; j < QBox->num; j++) {
                    value += this->qcoefficients[j]*QBox->state[i + offset*j];
                }
                data[i] = value;
            }*/

            this->KeysRegistered[GLFW_KEY_ENTER] = GL_TRUE;
        }

        if (this->Keys[GLFW_KEY_A] && !this->KeysRegistered[GLFW_KEY_A]) {
            this->qstate_id -= 1;
            if (this->qstate_id < 0) {
                this->qstate_id = QBox->num - 1;
            }
            this->shader_range = QBox->state_range[this->qstate_id];
            this->KeysRegistered[GLFW_KEY_A] = GL_TRUE;
        }

        if (this->Keys[GLFW_KEY_D] && !this->KeysRegistered[GLFW_KEY_D]) {
            this->qstate_id += 1;
            if (this->qstate_id >= QBox->num) {
                this->qstate_id = 0;
            }
            this->shader_range = QBox->state_range[this->qstate_id];
            this->KeysRegistered[GLFW_KEY_D] = GL_TRUE;
        }
    } else if (this->State == STATE_PRE_TIME_EVOLUTION) {
//            GLboolean Button_mouse[8];
//    GLboolean Button_mouseRegistered[8];

        if (this->Button_mouse[GLFW_MOUSE_BUTTON_LEFT] && !this->Button_mouseRegistered[GLFW_MOUSE_BUTTON_LEFT]) {
            this->State = STATE_TIME_EVOLUTION;
            this->shader_program = this->probability_density_shader;
            this->KeysRegistered[GLFW_MOUSE_BUTTON_LEFT] = GL_TRUE;
        }

        if (this->Keys[GLFW_KEY_ENTER] && !this->KeysRegistered[GLFW_KEY_ENTER]) {
            this->State = STATE_EIGENVECTOR;
            this->shader_program = this->wave_function_shader;
            this->KeysRegistered[GLFW_KEY_ENTER] = GL_TRUE;
        }
    } else if (this->State == STATE_TIME_EVOLUTION) {
        if (this->Keys[GLFW_KEY_ENTER] && !this->KeysRegistered[GLFW_KEY_ENTER]) {
            this->State = STATE_EIGENVECTOR;
            this->shader_program = this->wave_function_shader;
            this->KeysRegistered[GLFW_KEY_ENTER] = GL_TRUE;
        }
    }

    if (this->Keys[GLFW_KEY_W]) {
        this->shader_range += this->shader_range*dt;
    }

    if (this->Keys[GLFW_KEY_S]) {
        this->shader_range -= this->shader_range*dt;
    }

    if (this->Keys[GLFW_KEY_R] && !this->KeysRegistered[GLFW_KEY_R]) {
        this->shader_range = QBox->state_range[this->qstate_id];
        this->KeysRegistered[GLFW_KEY_R] = GL_TRUE;
    }
}

void StateMachine::ProcessScroll(glm::vec2 mouse_scroll_offset) {
    gausian_width += mouse_scroll_offset.y*this->mouse_scroll_sensifivity;
}

void StateMachine::Update(GLfloat dt) {
    //calculate exponentaly smoothed FPS
    this->fps = this->fps*this->fps_smoothing + (1.0f - this->fps_smoothing)/dt;

    if (this->State == STATE_PRE_TIME_EVOLUTION) {

        glm::vec2* data = new glm::vec2[QBox->n*QBox->n];
        for (int i = 0; i < QBox->n; i++) {
            for (int j = 0; j < QBox->n; j++) {
                glm::vec2 value = glm::vec2(2.0f*i/(float)QBox->n - 1.0f, 2.0f*j/(float)QBox->n - 1.0f) - this->mouse_pos;
                data[i + QBox->n*j] = glm::vec2(1.0, 1.0)*std::exp(-(value.x*value.x + value.y*value.y)*gausian_width*gausian_width);
            }
        }

        QBox->find_coefficients(data, this->qcoefficients);
        QBox->normalize(this->qcoefficients);

        glUseProgram(this->shader_program);
        glUniform2fv(glGetUniformLocation(this->shader_program, "qcoefficients"), QBox->num, glm::value_ptr(*this->qcoefficients));
    }


    if (this->State == STATE_TIME_EVOLUTION) {
        this->time += 200.0f*dt;
    }
}

void StateMachine::Render() {
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D_ARRAY, this->texture_handel);

    glUseProgram(this->shader_program);
    glUniform1f(glGetUniformLocation(this->shader_program, "shader_range"), this->shader_range);
    glUniform1f(glGetUniformLocation(this->shader_program, "time"), this->time);
    glUniform1i(glGetUniformLocation(this->shader_program, "qstate_id"), this->qstate_id);

    glBindVertexArray(this->VAO);
    glDrawArrays(GL_TRIANGLES, 0, 6);

    std::stringstream stream_fps;
    stream_fps.precision(1);
    stream_fps << std::fixed << this->fps;
    Text->RenderText("FPS: " + stream_fps.str(), glm::vec2(10.0f, 5.0f), 1.0f);

    if (this->State == STATE_EIGENVECTOR)
        Text->RenderText("Press ENTER to switch mode: Eigenvectors", glm::vec2(150.0f, 5.0f), 1.0f);
    if (this->State == STATE_PRE_TIME_EVOLUTION)
        Text->RenderText("Left click to select wavefunction", glm::vec2(150.0f, 25.0f), 1.0f);
    if (this->State == STATE_TIME_EVOLUTION || this->State == STATE_PRE_TIME_EVOLUTION)
        Text->RenderText("Press ENTER to switch mode: Time evolution", glm::vec2(150.0f, 5.0f), 1.0f);
}
