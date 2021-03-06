/**
 * @file
 *
 * \brief Basic exception class that can store an error message.
 *
 */
#ifndef EXCEPTION_H
#define EXCEPTION_H

#include <string>

namespace rcombinator
{
    /** Basic class to represent exceptions.
     *  Stores an error message.
     */
    class Exception
    {
    private:
        /// A helpful diagnostic message
        const std::string error_msg;

    public:
        /** Basic constructor for an exception that is to be thrown.
         *  Takes the error message as input argument.
         */
        Exception(std::string error_msg) :
            error_msg(error_msg) {}

        /** The error message for this exception.
         */
        std::string what() const { return error_msg; }
    };
}

#endif //EXCEPTION_H
