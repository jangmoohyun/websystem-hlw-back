export default (sequelize, DataTypes) => {
    const HeroineLike = sequelize.define(
        'HeroineLike',
        {
            id: {
                type: DataTypes.BIGINT.UNSIGNED,
                primaryKey: true,
                autoIncrement: true,
            },
            likeValue: {
                type: DataTypes.TINYINT,
                allowNull: false,
                defaultValue: 0,
            },
        },
        {
            tableName: 'heroine_like',
            timestamps: false,
        }
    );

    HeroineLike.associate = (models) => {
        HeroineLike.belongsTo(models.Progress, {
            as: 'progress',
            foreignKey: {
                name: 'progressId',
                field: 'progress_id',
                allowNull: false,
            },
            onDelete: 'CASCADE',
        });

        HeroineLike.belongsTo(models.Heroine, {
            as: 'heroine',
            foreignKey: {
                name: 'heroineId',
                field: 'heroine_id',
                allowNull: false,
            },
            onDelete: 'CASCADE',
        });
    };

    return HeroineLike;
};