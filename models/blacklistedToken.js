export default (sequelize, DataTypes) => {
    const BlacklistedToken = sequelize.define(
        'BlacklistedToken',
        {
            id: {
                type: DataTypes.BIGINT.UNSIGNED,
                primaryKey: true,
                autoIncrement: true,
            },
            token: {
                type: DataTypes.STRING(500),
                allowNull: false,
                unique: true,
            },
            expiresAt: {
                type: DataTypes.DATE,
                allowNull: false,
            },
        },
        {
            tableName: 'blacklisted_tokens',
            timestamps: true,
            indexes: [
                {
                    fields: ['token'],
                    unique: true,
                },
                {
                    fields: ['expiresAt'],
                },
            ],
        }
    );

    return BlacklistedToken;
};

