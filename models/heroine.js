export default (sequelize, DataTypes) => {
    const Heroine = sequelize.define(
        'Heroine',
        {
            id: {
                type: DataTypes.BIGINT.UNSIGNED,
                primaryKey: true,
                autoIncrement: true,
            },
            name: {
                type: DataTypes.STRING(100),
                allowNull: false,
            },
            language: {
                type: DataTypes.STRING(50),
                allowNull: false,
            },
        },
        {
            tableName: 'heroine',
            timestamps: false,
        }
    );

    Heroine.associate = (models) => {
        // 1:N = Heroine : HeroineImage
        Heroine.hasMany(models.HeroineImage, {
            as: 'images',
            foreignKey: 'heroineId',
        });

        // 1:N = Heroine : HeroineLike
        Heroine.hasMany(models.HeroineLike, {
            as: 'likes',
            foreignKey: 'heroineId',
        });
    };

    return Heroine;
};