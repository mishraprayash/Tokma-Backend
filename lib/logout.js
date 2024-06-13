export const logout = async (req, res, next) => {
    try {
        // remove the existing cookies
        res.clearCookie('token')
        return res.status(200).json({ message: 'Logout Success' })
    } catch (error) {
        console.log(error);
        return res.status(500).json({ error });
    }
}