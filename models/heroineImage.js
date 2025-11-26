export default (sequelize, DataTypes) => {
    const HeroineImage = sequelize.define(
        'HeroineImage',
        {
            id: {
                type: DataTypes.BIGINT.UNSIGNED,
                primaryKey: true,
                autoIncrement: true,
            },
            description: {
                type: DataTypes.STRING(255),
                allowNull: true,
            },
            imageUrl: {
                type: DataTypes.STRING(512),
                allowNull: false,
                field: 'image_url',
            },
        },
        {
            tableName: 'heroine_img',
            timestamps: true,
        }
    );

    HeroineImage.associate = (models) => {
        HeroineImage.belongsTo(models.Heroine, {
            as: 'heroine',
            foreignKey: {
                name: 'heroineId',
                field: 'heroine_id',
                allowNull: false,
            },
            onDelete: 'CASCADE',
        });
    };

    return HeroineImage;
};