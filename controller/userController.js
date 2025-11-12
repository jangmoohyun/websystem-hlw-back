import * as userService from '../service/userService.js';

export const getUser = async (req, res) => {
    const user = await userService.findUserById(req.params.id);
    res.json({ success: true, data: user });
};

export const createUser = async (req, res) => {
    const newUser = await userService.createUser(req.body);
    res.status(201).json({ success: true, data: newUser });
};